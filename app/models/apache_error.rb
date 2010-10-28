class ApacheError < ActiveRecord::Base
  # [Tue Apr 20 00:00:35 2010] [error] [client 193.109.122.33] request failed: error reading the headers
  
  def self.parse_log_line(log_line)
    if log_line =~ /^\[(.+?)\]\s+\[(\w+)\]\s+\[client\s+([\d\.]+)\]\s+(.*)$/
      { :level => $2, :client => $3, :message => $4, :observed_at => DateTime.strptime($1, "%d/%b/%Y:%H:%M:%S %Z") }
    end
  end
end
