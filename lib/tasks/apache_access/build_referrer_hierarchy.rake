namespace :build do
  namespace :hierarchy do
    task :referrer => :environment do
      # Group log events based on referrer strings - with observed_at used to scope grouping
      events = ApacheAccess.tagged_with("wordpress").ip_address("10.0.1.2").user_agent("Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.3) Gecko/20100401 Firefox/3.6.3")
      events.where(:referer => "http://www.domain.org/").all.each do |event|
        parent = events.url("/").order(:observed_at).all.sort { |a, b| a.observed_at == b.observed_at ? a.counter <=> b.counter : a.observed_at <=> b.observed_at }.first
        event.move_to_child_of parent
      end
      events.where(:referer => "http://www.domain.org/wp-content/themes/optimize/css/style.css").all.each do |event|
        parent = events.url("/wp-content/themes/optimize/css/style.css").order(:observed_at).all.sort { |a, b| a.observed_at == b.observed_at ? a.counter <=> b.counter : a.observed_at <=> b.observed_at }.first
        event.move_to_child_of parent
      end
      events.where(:referer => "http://www.domain.org/wp-content/themes/optimize/css/prettyPhoto.css").all.each do |event|
        parent = events.url("/wp-content/themes/optimize/css/prettyPhoto.css").order(:observed_at).all.sort { |a, b| a.observed_at == b.observed_at ? a.counter <=> b.counter : a.observed_at <=> b.observed_at }.first
        event.move_to_child_of parent
      end
      events.where(:referer => "http://www.domain.org/login/").all.each do |event|
        parent = events.url("/login").order(:observed_at).all.sort { |a, b| a.observed_at == b.observed_at ? a.counter <=> b.counter : a.observed_at <=> b.observed_at }.first
        event.move_to_child_of parent
      end
      
      events = ApacheAccess.tagged_with("wordpress").ip_address("10.0.1.2").user_agent("Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_2; en-us) AppleWebKit/531.22.7 (KHTML, like Gecko) Version/4.0.5 Safari/531.22.7")
      events.where(:referer => "http://www.domain.org/").all.each do |event|
        parent = events.url("/").order(:observed_at).all.sort { |a, b| a.observed_at == b.observed_at ? a.counter <=> b.counter : a.observed_at <=> b.observed_at }.first
        event.move_to_child_of parent
      end
      
      events = ApacheAccess.tagged_with("wordpress").ip_address("201.229.176.217")
      events.referer("http://24.4.108.196/").all.each do |event|
        parent = events.url("/").order(:observed_at).all.sort { |a, b| a.observed_at == b.observed_at ? a.counter <=> b.counter : a.observed_at <=> b.observed_at }.first
        event.move_to_child_of parent
      end
      events.referer("http://24.4.108.196/wp-content/themes/optimize/css/style.css").all.each do |event|
        parent = events.url("/wp-content/themes/optimize/css/style.css").order(:observed_at).all.sort { |a, b| a.observed_at == b.observed_at ? a.counter <=> b.counter : a.observed_at <=> b.observed_at }.first
        event.move_to_child_of parent
      end
      
      events = ApacheAccess.tagged_with("wordpress").ip_address("208.80.69.69")
      events.where(:referer => "http://www.domain.org/").all.each do |event|
        parent = events.url("/").order(:observed_at).all.sort { |a, b| a.observed_at == b.observed_at ? a.counter <=> b.counter : a.observed_at <=> b.observed_at }.first
        event.move_to_child_of parent
      end
      events.where(:referer => "http://www.domain.org/login/").all.each do |event|
        parent = events.url("/login").order(:observed_at).all.sort { |a, b| a.observed_at == b.observed_at ? a.counter <=> b.counter : a.observed_at <=> b.observed_at }.first
        event.move_to_child_of parent
      end
      
      events = ApacheAccess.tagged_with("wordpress").ip_address("65.88.2.5")
      events.where(:referer => "http://www.domain.org/signup").all.each do |event|
        parent = events.url("/signup/").order(:observed_at).all.sort { |a, b| a.observed_at == b.observed_at ? a.counter <=> b.counter : a.observed_at <=> b.observed_at }.first
        event.move_to_child_of parent
      end
      events.where(:referer => "http://www.domain.org/media/css/style.css").all.each do |event|
        parent = events.url("/media/css/style.css").order(:observed_at).all.sort { |a, b| a.observed_at == b.observed_at ? a.counter <=> b.counter : a.observed_at <=> b.observed_at }.first
        event.move_to_child_of parent
      end
      
      events = ApacheAccess.tagged_with("wordpress").ip_address("190.166.87.164")
      events.where(:referer => "http://24.4.108.196/").all.each do |event|
        parent = events.url("/").order(:observed_at).all.sort { |a, b| a.observed_at == b.observed_at ? a.counter <=> b.counter : a.observed_at <=> b.observed_at }.first
        event.move_to_child_of parent
      end

      events = ApacheAccess.tagged_with("wordpress").ip_address("190.167.70.87")
      events.where(:referer => "http://24.4.108.196/").all.each do |event|
        parent = events.url("/").order(:observed_at).all.sort { |a, b| a.observed_at == b.observed_at ? a.counter <=> b.counter : a.observed_at <=> b.observed_at }.first
        event.move_to_child_of parent
      end
    end
  end
end