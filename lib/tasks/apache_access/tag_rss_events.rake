#    Log Mysteries: partial answer for Honeynet challenge (see http://honeynet.org/challenges/2010_5_log_mysteries)
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
    task :rss => :environment do 
      ApacheAccess.ip_address("10.0.1.2").user_agent("Apple-PubSub/65.12.1").all.each do |event|
        event.tag_list = "rss"
        event.save!
      end

      ApacheAccess.ip_address("208.80.69.74").user_agent("Apple-PubSub/65.12.1").all.each do |event|
        event.tag_list = "rss"
        event.save!
      end

      ApacheAccess.ip_address("65.88.2.5").user_agent("Apple-PubSub/65.12.1").all.each do |event|
        event.tag_list = "rss"
        event.save!
      end

      ApacheAccess.ip_address("76.191.195.140").user_agent("Apple-PubSub/65.12.1").all.each do |event|
        event.tag_list = "rss"
        event.save!
      end
    end
  end
end