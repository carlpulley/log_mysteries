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
