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

namespace :process do
  task :wordpress => :environment do
    archive = "evidence/wordpress-2.9.2.tar.gz"
    
    puts `curl http://wordpress.org/wordpress-2.9.2.tar.gz -o #{archive}` unless FileTest.file?(archive)
  
    `tar -ztvf #{archive}`.split("\n").map do |d| 
      Wordpress.create!({ :archive => archive, :name => $4, :observed_at => DateTime.strptime($3, "%d %b %Y"), :size => $2.to_i, :directory => ($1 == 'd') }) if d =~ /^([d\-]).*?www\-data\s+(\d+)\s+(.*?)\s+wordpress(.*)$/
    end
  end
end
