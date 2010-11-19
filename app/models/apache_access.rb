#    Log Mysteries: partial answer for Honeynet challenge (see http://honeynet.org/challenges/2010_5_log_mysteries)
#    Copyright (C) 2010  Dr. Carl J. Pulley
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

class ApacheAccess < ActiveRecord::Base
  acts_as_taggable_on :tags
  acts_as_nested_set
  
  belongs_to :file_object
  belongs_to :ip_address
  has_many :matches
  has_many :archive_contents, :through => :matches
  
  scope :get, lambda { where(:http_method => 'GET') }
  scope :url, lambda { |url| where(["http_url like ?", "#{url}%"]) }
  scope :ip_address, lambda { |addr| where(["remote like ?", "#{addr}%"]) }
  scope :referer, lambda { |referer| where(["referer like ?", "#{referer}%"]) }
  scope :user_agent, lambda { |agent| where(agent == "-" ? ["user_agent like '-'"] : ["user_agent like ?", "%#{agent}%"]) }

  # NOTES:
  #  Using the Apache2 documentation for LogFormat we get that the NCSA extended/combined log format configuration parameter is:
  #    %h %l %u %t "%r" %>s %b "%{Referer}i" "%{User-agent}i"
  # Comparing this format string against a sample www-access.log line:
  #    65.88.2.5 - - [23/Apr/2010:11:21:40 -0700] "POST /signup/ HTTP/1.1" 302 20 "http://www.domain.org/signup/" "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.3) Gecko/20100401 Firefox/3.6.3" f55iHQoAAQ4AAECGNyIAAAAc 519193
  # allows us to determine that the format string is probably as follows:
  #    %h %l %u %t "%r" %>s %b "%{Referer}i" "%{User-agent}i" ?? %D
  # where ?? represents an unknown quantity. Without additional configuration data, it is impossible to accurately determine the contents of the httpd.conf LogFormat directive!
  
  def self.parse_log_line(log_line)
    if log_line =~ /^([\d.]+)\s+(\w+|-)\s+(\w+|-)\s+\[([\d\w:\/\s\+\-]+)\]\s+\"([A-Z]+)\s+(.*?)\s+HTTP\/([\d\.]+)\"\s+(\d{3})\s+(\d+|-)\s+\"(.*?)\"\s+\"(.*?)\"\s+(.*?)\s+(\d+)$/
      { :remote => $1, :host => $2, :user => $3, :http_method => $5, :http_url => $6, :http_version => $7, :result => $8.to_i, :bytes => $9.try(:to_i), :referer => $10, :user_agent => $11, :unknown => $12, :processing_time => $13.try(:to_i), :observed_at => DateTime.strptime($4, "%d/%b/%Y:%H:%M:%S %Z") }
    end
  end
  
  def to_s
    "#{remote} #{host} #{user} [#{observed_time "%d/%b/%Y:%H:%M:%S %z"}] \"#{http_method} #{http_url} HTTP/#{http_version}\" #{result} #{bytes == 0 ? "-" : bytes} \"#{referer}\" \"#{user_agent}\" #{unknown} #{processing_time}"
  end
  
  def to_html(max_bytes, max_processing_time)
    "#{observed_time "%d/%b/%Y:%H:%M:%S %z"} <script type=\"text/javascript+protovis\">sparkcolour(#{result.to_json}).render();</script> <script type=\"text/javascript+protovis\">sparklength(#{bytes.to_json}, #{max_bytes}).render();</script> <script type=\"text/javascript+protovis\">sparklength(#{processing_time.to_json}, #{max_processing_time}).render();</script> #{counter} #{pid} #{thread_index} #{referer == '-' ? http_method : "#{referer} -> #{http_method}"} #{http_url}"
  end
  
  def timestamp
    decode_unknown[0..3].split("").map { |n| n.ord }.inject(0) { |t, n| t*256 + n }/10**6 unless unknown == '-'
  end
  
  def local
    decode_unknown[4..7].split("").map { |n| n.ord }.join(".") unless unknown == '-'
  end
  
  def pid
    decode_unknown[8..11].split("").map { |n| n.ord }.inject(0) { |t, n| t*256 + n } unless unknown == '-'
  end
  
  def thread_index
    decode_unknown[14..17].split("").map { |n| n.ord }.inject(0) { |t, n| t*256 + n } unless unknown == '-'
  end
  
  def counter
    decode_unknown[12..13].split("").map { |n| n.ord }.inject(0) { |t, n| t*256 + n } unless unknown == '-'
  end
  
  def observed_time(format)
    observed_at.in_time_zone('Pacific Time (US & Canada)').strftime(format)
  end
  
  private
  
  def decode_unknown
    Base64.decode64(unknown.tr('-', '/').tr('@', '+'))
  end
end
