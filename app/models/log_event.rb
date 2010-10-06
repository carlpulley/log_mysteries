class LogEvent < ActiveRecord::Base
  serialize :http, Hash
  
  scope ip_address, lambda { |addr| where(:remote => addr) }
  scope user_agent, lambda { |agent| where(:user_agent => agent) }

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
      { :remote => $1, :host => $2, :user => $3, :http => { :verb => $5, :uri => $6, :version => $7 }, :result => $8.to_i, :bytes => $9.try(:to_i), :referer => $10, :user_agent => $11, :unknown => $12, :processing_time => $13.try(:to_i), :created_at => DateTime.strptime($4, "%d/%b/%Y:%H:%M:%S %Z") }
    end
  end
  
  def to_s
    "#{remote} #{host} #{user} [#{created_at.in_time_zone('Pacific Time (US & Canada)').strftime("%d/%b/%Y:%H:%M:%S %z")}] \"#{http[:verb]} #{http[:uri]} HTTP/#{http[:version]}\" #{result} #{bytes == 0 ? "-" : bytes} \"#{referer}\" \"#{user_agent}\" #{unknown} #{processing_time}"
  end
end
