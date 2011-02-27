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
    
namespace :build do
  namespace :names do
    namespace :url do
      task :basename => :environment do
        ArchiveContent.where(:directory => false).all.each do |archive|
          if archive.name =~ /\/([^\/]+)$/
            ApacheAccess.where(["http_url like ?", "%#{$1}%"]).all.each do |event|
              match = Match.new(:archive_content => archive, :apache_access => event)
              match.tag_list << "match"
              match.tag_list << "basename"
              match.save!
            end
          end
        end
      end
    end
  end
end