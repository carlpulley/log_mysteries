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

namespace :tag do
  namespace :events do
    task :maintenance => :environment do 
      Sudo.command("/usr/bin/vi").all.each do |event|
        event.tag_list << "maintenance"
        event.save!
      end
      
      Sudo.command("/bin/sed").all.each do |event|
        event.tag_list << "maintenance"
        event.save!
      end
      
      Sudo.command("/usr/bin/tee").all.each do |event|
        event.tag_list << "maintenance"
        event.save!
      end
      
      Sudo.command("/usr/bin/svn").all.each do |event|
        event.tag_list << "maintenance"
        event.save!
      end
      
      Sudo.command("/usr/bin/patch").all.each do |event|
        event.tag_list << "maintenance"
        event.save!
      end
      
      Sudo.command("/usr/bin/apt-get").all.each do |event|
        event.tag_list << "maintenance"
        event.save!
      end
      
      Sudo.command("/usr/bin/dpkg").all.each do |event|
        event.tag_list << "maintenance"
        event.save!
      end
    end
  end
end
