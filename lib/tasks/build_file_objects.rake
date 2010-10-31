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

def walk_path_list(node, path)
  if path.empty?
    node
  else
    child = node.children.select { |c| c.name == path[0] }.first
    if child.nil?
      child = FileObject.create!(:name => path.first)
      child.move_to_child_of(node)
    end
    walk_path_list(child, path[1..-1])
  end
end

namespace :build do
  task :file_objects => :environment do
    ApacheAccess.where(:result => 200).where("http_url not like 'http://%'").all.each do |event|
      if event.http_url =~ /^(.+?)(\?.+)?$/
        leaf = walk_path_list FileObject.find_or_create_by_name("/"), $1.split("/").select { |n| n != "" }
        event.file_object = leaf
        event.save!
      end
    end
  end
end