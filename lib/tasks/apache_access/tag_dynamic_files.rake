namespace :tag do
  namespace :files do
    task :dynamic => :environment do 
      ApacheAccess.where("http_url like '%#.php%'").all.each do |event|
        if event.http_method == "GET" and event.http_url =~ /\.php(\?.+)?$/ and event.result == 200
          event.tag_list << "dynamic"
          event.save!
        end
      end
    end
  end
end
