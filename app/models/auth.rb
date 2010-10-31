#    <one line to give the program's name and a brief idea of what it does.>
#    Copyright (C) 2010  Carl J. Pulley
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

class Auth < ActiveRecord::Base
  acts_as_taggable_on :tags
  #acts_as_nested_set
  
  def self.parse_log_line(log_line)
    if log_line =~ /^([\w]{3}\s+\d+\s+[\d:]+)\s+([\d\w\-]+)\s+([\d\w]+)(\[(\d+)\])?:\s+(.*)$/
      # NOTE: in the following, we've added in missing timezone and year data to our log line timestamps. The year used is based on the last modified 
      #   timestamp for our auth.log file (as found in the zip archive). The timezone used is based on those found in the apache2/www-*.log files.
      { :observed_at => DateTime.strptime("2010 #{$1} -0700", "%Y %b %d %H:%M:%S %z"),  :host => $2, :process => $3, :pid => $5, :message => $6 }
    end
  end
  
  def to_s
    "#{observed_at.in_time_zone('Pacific Time (US & Canada)').strftime("%b %e %H:%M:%S")} #{host} #{process}#{"[#{pid}]" unless pid.nil?}: #{message_to_s}"
  end
  
  def message_to_s
    message
  end
end
