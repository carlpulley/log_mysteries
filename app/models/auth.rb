class Auth < ActiveRecord::Base
  acts_as_taggable_on :tags
  acts_as_nested_set
  
  def self.parse_log_line(log_line)
    if log_line =~ /^([\w]{3}\s+\d+\s+[\d:]+)\s+([\d\w\-]+)\s+([\d\w]+)(\[(\d+)\])?:\s+(.*)$/
      { :observed_at => DateTime.strptime($1, "%b %d %H:%M:%S"),  :host => $2, :process => $3, :pid => $5, :message => $6 }
    end
  end
end
