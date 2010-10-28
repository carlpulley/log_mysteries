namespace :tag do
  namespace :events do
    task :wordpress => :environment do 
      ApacheAccess.url("/wp-content/").all.each do |event|
        event.tag_list << "wordpress"
        event.save!
      end
      
      ApacheAccess.url("/wp-includes/").all.each do |event|
        event.tag_list << "wordpress"
        event.save!
      end
      
      ApacheAccess.url("/wp-cron").all.each do |event|
        event.tag_list << "wordpress"
        event.save!
      end
    end
  end
end