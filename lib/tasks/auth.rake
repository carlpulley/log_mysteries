#    Log Mysteries: partial answer for Honeynet challenge
#    Reference: http://honeynet.org/challenges/2010_5_log_mysteries
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

namespace :process do
  task :auth => :environment do
    archive = "sanitized_log/auth.log"
    
    puts `unzip -d evidence evidence/sanitized_log.zip #{archive}` unless FileTest.file?("evidence/#{archive}")
  
    open("evidence/#{archive}", "r").each do |line|
      unless Auth.create(Auth.parse_log_line(line))
        puts "Skipping line: #{line}"
      end
    end
  end
end
