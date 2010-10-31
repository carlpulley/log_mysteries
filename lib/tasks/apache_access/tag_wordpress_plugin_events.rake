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
    namespace :wordpress do
      task :plugins => :environment do 
        ApacheAccess.tagged_with("wordpress").url("/wp-content/plugins").all.each do |event|
          event.tag_list << "plugin"
          event.tag_list << "contact-form-7" if event.http_url =~ /contact\-form\-7/
          event.tag_list << "google-syntax-highlighter" if event.http_url =~ /google\-syntax\-highlighter/
          event.tag_list << "google-analyticator" if event.http_url =~ /google\-analyticator/
          event.save!
        end
      end
    end
  end
end
