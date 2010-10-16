class LogEvent < ActiveRecord::Base
  serialize :http, Hash
  
  acts_as_taggable_on :tags
  
  scope :get, lambda { where("http like '%\n:verb: GET%'") }
  scope :url, lambda { |url| where(["http like ?", "%\n:uri: #{url}%"]) }
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
      { :remote => $1, :host => $2, :user => $3, :http => { :verb => $5, :uri => $6, :version => $7 }, :result => $8.to_i, :bytes => $9.try(:to_i), :referer => $10, :user_agent => $11, :unknown => $12, :processing_time => $13.try(:to_i), :observed_at => DateTime.strptime($4, "%d/%b/%Y:%H:%M:%S %Z") }
    end
  end
  
  def to_s
    "#{remote} #{host} #{user} [#{observed_at.in_time_zone('Pacific Time (US & Canada)').strftime("%d/%b/%Y:%H:%M:%S %z")}] \"#{http[:verb]} #{http[:uri]} HTTP/#{http[:version]}\" #{result} #{bytes == 0 ? "-" : bytes} \"#{referer}\" \"#{user_agent}\" #{unknown} #{processing_time}"
  end
  
  def to_html(log_events)
    "#{observed_at.in_time_zone('Pacific Time (US & Canada)').strftime("%d/%b/%Y:%H:%M:%S %z")} <script type=\"text/javascript+protovis\">sparkcolour(#{result.to_json}).render();</script> <script type=\"text/javascript+protovis\">sparklength(#{bytes.to_json}, #{log_events.maximum(:bytes)}).render();</script> <script type=\"text/javascript+protovis\">sparklength(#{processing_time.to_json}, #{log_events.maximum(:processing_time)}).render();</script> #{pid} #{thread_index} #{referer == '-' ? http[:verb] : "#{referer} -> #{http[:verb]}"} #{http[:uri]}"
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
  
  private
  
  def decode_unknown
    Base64.decode64(unknown.tr('-', '/').tr('@', '+'))
  end
end
