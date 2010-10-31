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

class ApacheError < ActiveRecord::Base
  # [Tue Apr 20 00:00:35 2010] [error] [client 193.109.122.33] request failed: error reading the headers
  
  def self.parse_log_line(log_line)
    if log_line =~ /^\[(.+?)\]\s+\[(\w+)\]\s+\[client\s+([\d\.]+)\]\s+(.*)$/
      { :level => $2, :client => $3, :message => $4, :observed_at => DateTime.strptime("#{$1} -0700", "%a %b %d %H:%M:%S %Y %Z") }
    end
  end
  
  def to_s
    "[#{observed_at.in_time_zone('Pacific Time (US & Canada)').strftime("%a %b %d %H:%M:%S %Y")}] [#{level}] [client #{client}] #{message}"    
  end
end
