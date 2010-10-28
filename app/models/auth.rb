class Auth < ActiveRecord::Base
  acts_as_taggable_on :tags
  acts_as_nested_set
  
  def self.parse_log_line(log_line)
    if log_line =~ /^([\w]{3}\s+\d+\s+[\d:]+)\s+([\d\w\-]+)\s+([\d\w]+)(\[(\d+)\])?:\s+(.*)$/
      # NOTE: in the following, we've added in missing timezone and year data to our log line timestamps. The year used is based on the last modified 
      #   timestamp for our auth.log file (as found in the zip archive). The timezone used is based on those found in the apache2/www-*.log files.
      { :observed_at => DateTime.strptime("2010 #{$1} -0700", "%Y %b %d %H:%M:%S %z"),  :host => $2, :process => $3, :pid => $5, :message => $6 }
    end
  end
end
