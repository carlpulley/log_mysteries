namespace :tag do
  namespace :events do
    task :rss => :environment do 
      ApacheAccess.ip_address("10.0.1.2").user_agent("Apple-PubSub/65.12.1").all.each do |event|
        event.tag_list = "rss"
        event.save!
      end

      ApacheAccess.ip_address("208.80.69.74").user_agent("Apple-PubSub/65.12.1").all.each do |event|
        event.tag_list = "rss"
        event.save!
      end

      ApacheAccess.ip_address("65.88.2.5").user_agent("Apple-PubSub/65.12.1").all.each do |event|
        event.tag_list = "rss"
        event.save!
      end

      ApacheAccess.ip_address("76.191.195.140").user_agent("Apple-PubSub/65.12.1").all.each do |event|
        event.tag_list = "rss"
        event.save!
      end
    end
  end
end