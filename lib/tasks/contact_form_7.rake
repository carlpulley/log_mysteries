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
  task :contact_form_7 => :environment do
    archive = "evidence/contact-form-7.2.1.1.zip"
    
    puts `curl http://downloads.wordpress.org/plugin/contact-form-7.2.1.1.zip -o #{archive}` unless FileTest.file?(archive)
    
    `unzip -l #{archive}`.split("\n").map do |d| 
      ContactForm7.create!({ :archive => archive, :name => $3, :observed_at => DateTime.strptime($2, "%m-%d-%y %H:%M"), :size => $1.to_i, :directory => ($4 == '/') }) if d =~ /^\s*(\d+)\s+([\d\-]+\s+[\d:]+)\s+(contact\-form\-7.*?)(\/?)$/
    end
  end
end
