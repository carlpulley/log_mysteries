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
    task :apache => :environment do 
      Sudo.command("apache").all.each do |event|
        event.tag_list << "apache"
        event.tag_list << "start" if event.message[:command] =~ /^\/etc\/init.d\/apache2 start$/ or event.message[:command] =~ /^\/etc\/init.d\/apache2 restart$/
        event.tag_list << "stop" if event.message[:command] =~ /^\/etc\/init.d\/apache2 stop$/ or event.message[:command] =~ /^\/etc\/init.d\/apache2 restart$/ or event.message[:command] =~ /^\/usr\/bin\/killall .*?apache2$/
        event.save!
      end
    end
  end
end
