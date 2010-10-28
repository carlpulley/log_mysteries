namespace :tag do
  namespace :files do
    task :dynamic => :environment do 
      ApacheAccess.where("http like '%#.php%'").all.each do |event|
        if event.http[:verb] == "GET" and event.http[:uri] =~ /\.php(\?.+)?$/ and event.result == 200
          event.tag_list << "dynamic"
          event.save!
        end
      end
    end
  end
end
