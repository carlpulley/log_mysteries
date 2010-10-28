namespace :tag do
  namespace :events do
    task :scan => :environment do 
      ApacheAccess.ip_address("123.11.240.130").user_agent("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)").all.each do |event|
        event.tag_list = "proxy, scan"
        event.save!
      end

      ApacheAccess.ip_address("123.4.42.80").user_agent("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)").all.each do |event|
        event.tag_list = "proxy, scan"
        event.save!
      end

      ApacheAccess.ip_address("123.4.51.181").user_agent("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)").all.each do |event|
        event.tag_list = "proxy, scan"
        event.save!
      end

      ApacheAccess.ip_address("123.4.59.174").user_agent("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)").all.each do |event|
        event.tag_list = "proxy, scan"
        event.save!
      end

      ApacheAccess.ip_address("123.4.59.21").user_agent("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)").all.each do |event|
        event.tag_list = "proxy, scan"
        event.save!
      end

      ApacheAccess.ip_address("125.45.106.168").user_agent("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)").all.each do |event|
        event.tag_list = "proxy, scan"
        event.save!
      end

      ApacheAccess.ip_address("125.45.106.180").user_agent("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)").all.each do |event|
        event.tag_list = "proxy, scan"
        event.save!
      end

      ApacheAccess.ip_address("193.109.122.15").user_agent("-").all.each do |event|
        event.tag_list = "port-6677, scan"
        event.save!
      end

      ApacheAccess.ip_address("193.109.122.18").user_agent("-").all.each do |event|
        event.tag_list = "port-6677, scan"
        event.save!
      end

      ApacheAccess.ip_address("93.109.122.33").user_agent("-").all.each do |event|
        event.tag_list = "proxy, scan"
        event.save!
      end

      ApacheAccess.ip_address("193.109.122.52").user_agent("pxyscand/2.1").all.each do |event|
        event.tag_list = "port-6677, scan"
        event.save!
      end

      ApacheAccess.ip_address("193.109.122.56").user_agent("pxyscand/2.1").all.each do |event|
        event.tag_list = "port-6677, scan"
        event.save!
      end

      ApacheAccess.ip_address("193.109.122.57").user_agent("pxyscand/2.1").all.each do |event|
        event.tag_list = "port-6677, scan"
        event.save!
      end

      ApacheAccess.ip_address("203.209.253.30").user_agent("iearthworm/1.0, iearthworm@yahoo.com.cn").all.each do |event|
        event.tag_list = "world-of-warcraft, scan"
        event.save!
      end

      ApacheAccess.ip_address("203.209.253.31").user_agent("iearthworm/1.0, iearthworm@yahoo.com.cn").all.each do |event|
        event.tag_list = "world-of-warcraft, scan"
        event.save!
      end

      ApacheAccess.ip_address("203.209.253.33").user_agent("iearthworm/1.0, iearthworm@yahoo.com.cn").all.each do |event|
        event.tag_list = "world-of-warcraft, scan"
        event.save!
      end

      ApacheAccess.ip_address("203.209.253.34").user_agent("iearthworm/1.0, iearthworm@yahoo.com.cn").all.each do |event|
        event.tag_list = "world-of-warcraft, scan"
        event.save!
      end
    
      ApacheAccess.ip_address("221.192.199.35").user_agent("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0)").all.each do |event|
        event.tag_list = "proxy, scan"
        event.save!
      end
      
      ApacheAccess.ip_address("221.194.47.162").user_agent("-").all.each do |event|
        event.tag_list = "proxy, scan"
        event.save!
      end
      
      ApacheAccess.ip_address("61.183.15.9").user_agent("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0)").all.each do |event|
        event.tag_list = "proxy, scan"
        event.save!
      end
      
      ApacheAccess.ip_address("92.62.43.77").user_agent("-").all.each do |event|
        event.tag_list = "port-6667, scan"
        event.save!
      end
      
      ApacheAccess.ip_address("193.109.122.33").user_agent("-").all.each do |event|
        event.tag_list = "port-6677, scan"
        event.save!
      end
    end
  end
end