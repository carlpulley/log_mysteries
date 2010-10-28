namespace :tag do
  namespace :files do
    task :static => :environment do 
      ApacheAccess.where("http like '%#.js%'").all.each do |event|
        if event.http[:verb] == "GET" and event.http[:uri] =~ /\.js(\?.+)?$/ and event.result == 200
          event.tag_list << "static"
          event.save!
        end
      end
      ApacheAccess.where("http like '%#.css%'").all.each do |event|
        if event.http[:verb] == "GET" and event.http[:uri] =~ /\.css(\?.+)?$/ and event.result == 200
          event.tag_list << "static"
          event.save!
        end
      end
      ApacheAccess.where("http like '%#.png%'").all.each do |event|
        if event.http[:verb] == "GET" and event.http[:uri] =~ /\.png(\?.+)?$/ and event.result == 200
         event.tag_list << "static"
         event.save!
       end
      end
      ApacheAccess.where("http like '%#.gif%'").all.each do |event|
        if event.http[:verb] == "GET" and event.http[:uri] =~ /\.gif(\?.+)?$/ and event.result == 200
          event.tag_list << "static"
          event.save!
        end
      end
      ApacheAccess.where("http like '%#.ico%'").all.each do |event|
        if event.http[:verb] == "GET" and event.http[:uri] =~ /\.ico(\?.+)?$/ and event.result == 200
          event.tag_list << "static"
          event.save!
        end
      end
      ApacheAccess.where("http like '%#.txt%'").all.each do |event|
        if event.http[:verb] == "GET" and event.http[:uri] =~ /\.txt(\?.+)?$/ and event.result == 200
          event.tag_list << "static"
          event.save!
        end
      end
    end
  end
end
