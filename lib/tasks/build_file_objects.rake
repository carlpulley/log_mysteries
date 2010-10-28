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
    ApacheAccess.get.where(:result => 200).where("http not like '%\n:uri: http://%'").all.each do |event|
      if event.http[:uri] =~ /^(.+?)(\?.+)?$/
        leaf = walk_path_list FileObject.find_or_create_by_name("/"), $1.split("/").select { |n| n != "" }
        event.file_object = leaf
        event.save!
      end
    end
  end
end