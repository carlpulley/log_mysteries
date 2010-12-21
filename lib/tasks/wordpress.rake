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
  task :wordpress => :environment do
    archive = "evidence/wordpress-2.9.2.tar.gz"
    
    puts `curl http://wordpress.org/wordpress-2.9.2.tar.gz -o #{archive}` unless FileTest.file?(archive)
  
    `tar -ztvf #{archive}`.split("\n").map do |d| 
      Wordpress.create!({ :archive => archive, :name => $4, :observed_at => DateTime.strptime($3, "%Y-%m-%d %H:%M"), :size => $2.to_i, :directory => ($1 == 'd') }) if d =~ /^([d\-]).*?www\-data\s+(\d+)\s+(.*?)\s+wordpress(.*)$/
    end
    
    `tar -zxvf #{archive} -C evidence wordpress/wp-includes/js/jquery/jquery.js`
    `tar -zxvf #{archive} -C evidence wordpress/wp-includes/js/jquery/jquery.form.js`
    `tar -zxvf #{archive} -C evidence wordpress/wp-includes/js/jquery/jquery.form.dev.js`
  end
end
