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
  namespace :files do
    task :static => :environment do 
      ApacheAccess.where("http_url like '%#.js%'").all.each do |event|
        if event.http_method == "GET" and event.http_url =~ /\.js(\?.+)?$/ and event.result == 200
          event.tag_list << "static"
          event.save!
        end
      end
      ApacheAccess.where("http_url like '%#.css%'").all.each do |event|
        if event.http_method == "GET" and event.http_url =~ /\.css(\?.+)?$/ and event.result == 200
          event.tag_list << "static"
          event.save!
        end
      end
      ApacheAccess.where("http_url like '%#.png%'").all.each do |event|
        if event.http_method == "GET" and event.http_url =~ /\.png(\?.+)?$/ and event.result == 200
         event.tag_list << "static"
         event.save!
       end
      end
      ApacheAccess.where("http_url like '%#.gif%'").all.each do |event|
        if event.http_method == "GET" and event.http_url =~ /\.gif(\?.+)?$/ and event.result == 200
          event.tag_list << "static"
          event.save!
        end
      end
      ApacheAccess.where("http_url like '%#.ico%'").all.each do |event|
        if event.http_method == "GET" and event.http_url =~ /\.ico(\?.+)?$/ and event.result == 200
          event.tag_list << "static"
          event.save!
        end
      end
      ApacheAccess.where("http_url like '%#.txt%'").all.each do |event|
        if event.http_method == "GET" and event.http_url =~ /\.txt(\?.+)?$/ and event.result == 200
          event.tag_list << "static"
          event.save!
        end
      end
    end
  end
end
