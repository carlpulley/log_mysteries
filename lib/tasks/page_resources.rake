namespace :add do
  namespace :page do
    task :resources => :environment do
      events = LogEvent.tagged_with(["wordpress", "blog"]).ip_address("10.0.1.2").user_agent("Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.3) Gecko/20100401 Firefox/3.6.3")
      root = events.where(:unknown => "bpvboQoAAQ4AAAHJDAYAAAAA").first
      events.where(:name => "www-media.log").url("/wp-content").where(:referer => "http://www.domain.org/").all.each do |event|
        event.move_to_child_of root
      end
      events.where(:name => "www-media.log").url("/wp-includes").where(:referer => "http://www.domain.org/").all.each do |event|
        event.move_to_child_of root
      end
      events.where(:name => "www-media.log").url("/wp-content").where(:referer => "http://www.domain.org/wp-content/themes/optimize/css/style.css").all.each do |event|
        event.move_to_child_of events.where(:unknown => "bqXXvQoAAQ4AAAHJDAcAAAAA").first
      end
      events.where(:name => "www-media.log").url("/wp-content").where(:referer => "http://www.domain.org/wp-content/themes/optimize/css/prettyPhoto.css").all.each do |event|
        event.move_to_child_of events.where(:unknown => "bqYKYAoAAQ4AAAHKDWoAAAAB").first
      end
      root = events.where(:unknown => "bs6AXAoAAQ4AAAHLDgQAAAAC").first
      events.where(:name => "www-media.log").url("/wp-content").where(:referer => "http://www.domain.org/login/").all.each do |event|
        event.move_to_child_of root
      end
      events.where(:name => "www-media.log").url("/wp-includes").where(:referer => "http://www.domain.org/login/").all.each do |event|
        event.move_to_child_of root
      end
      
      events = LogEvent.tagged_with(["wordpress", "blog"]).ip_address("10.0.1.2").user_agent("Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_2; en-us) AppleWebKit/531.22.7 (KHTML, like Gecko) Version/4.0.5 Safari/531.22.7")
      root = events.where(:unknown => "VqcDyAoAAQ4AAAQFlm0AAAAL").first
      events.where(:name => "www-media.log").url("/wp-content").where(:referer => "http://www.domain.org/").all.each do |event|
        event.move_to_child_of root
      end
      events.where(:name => "www-media.log").url("/wp-includes").where(:referer => "http://www.domain.org/").all.each do |event|
        event.move_to_child_of root
      end
  
      events = LogEvent.tagged_with(["wordpress", "blog"]).ip_address("190.166.87.164")
      events.where(:name => "www-media.log").url("/wp-content").all.each do |event|
        event.move_to_child_of events.where(:unknown => "Ia5VVgoAAQ4AAAQBiWkAAAAH").first
      end
      
      events = LogEvent.tagged_with(["wordpress", "blog"]).ip_address("190.167.70.87")
      events.where(:name => "www-media.log").url("/wp-content").all.each do |event|
        event.move_to_child_of events.where(:unknown => "92rhtAoAAQ4AAEP2EQgAAAAC").first
      end
      
      events = LogEvent.tagged_with(["wordpress", "blog"]).ip_address("201.229.176.217")
      events.where(:name => "www-media.log").url("/wp-content").all.each do |event|
        event.move_to_child_of events.where(:unknown => "-qYm5QoAAQ4AAEP3EbUAAAAD").first
      end
      
      events = LogEvent.tagged_with(["wordpress", "blog"]).ip_address("208.80.69.69")
      root = events.where(:unknown => "jip-mgoAAQ4AAHbZRh0AAAAH").first
      events.where(:name => "www-media.log").url("/wp-content").where(:referer => "http://www.domain.org/").all.each do |event|
        event.move_to_child_of root
      end
      events.where(:name => "www-media.log").url("/wp-includes").where(:referer => "http://www.domain.org/").all.each do |event|
        event.move_to_child_of root
      end
      events.where(:name => "www-media.log").url("/wp-content").where(:referer => "http://www.domain.org/login/").all.each do |event|
        event.move_to_child_of events.where(:unknown => "jqgQbwoAAQ4AAHbZRiEAAAAH").first
      end
      
      events = LogEvent.tagged_with(["wordpress", "blog"]).ip_address("65.88.2.5")
      roots = [events.where(:unknown => "ftX0hgoAAQ4AAEBqBRYAAAAE").first, events.where(:unknown => "ftXvPQoAAQ4AAEBpBEkAAAAD").first]
      root_index = 0
      events.where(:name => "www-media.log").url("/media").where(:referer => "http://www.domain.org/signup/").all.each do |event|
        event.move_to_child_of roots[root_index % 2]
        root_index = root_index + 1
      end
      roots = [events.where(:unknown => "ft9omwoAAQ4AAEBoA1gAAAAC").first, events.where(:unknown => "ft9lIAoAAQ4AAEBpBEoAAAAD").first]
      root_index = 0
      events.where(:name => "www-media.log").url("/media").where(:referer => "http://www.domain.org/media/css/style.css").all.each do |event|
        event.move_to_child_of roots[root_index % 2]
        root_index = root_index + 1
      end
    end
  end
end