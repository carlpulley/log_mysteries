class LogEvent < ActiveRecord::Base
  serialize :http, Hash
  
  scope ip_address, lambda { |addr| where(:remote => addr) }
  scope user_agent, lambda { |agent| where(:user_agent => agent) }
  
  def self.parse_log_line(log_line)
    if log_line =~ /^([\d.]+)\s+(\w+|-)\s+(\w+|-)\s+\[([\d\w:\/\s\+\-]+)\]\s+\"([A-Z]+)\s+(.*?)\s+HTTP\/([\d\.]+)\"\s+(\d{3})\s+(\d+|-)\s+\"(.*?)\"\s+\"(.*?)\"\s+(.*?)\s+(\d+)$/
      { :remote => $1, :host => $2, :user => $3, :http => { :verb => $5, :uri => $6, :version => $7 }, :result => $8.to_i, :bytes => $9.try(:to_i), :referer => $10, :user_agent => $11, :unknown => $12, :processing_time => $13.try(:to_i), :created_at => DateTime.strptime($4, "%d/%b/%Y:%H:%M:%S %Z") }
    end
  end
  
  def to_s
    "#{remote} #{host} #{user} [#{created_at.in_time_zone('Pacific Time (US & Canada)').strftime("%d/%b/%Y:%H:%M:%S %z")}] \"#{http[:verb]} #{http[:uri]} HTTP/#{http[:version]}\" #{result} #{bytes == 0 ? "-" : bytes} \"#{referer}\" \"#{user_agent}\" #{unknown} #{processing_time}"
  end
end
