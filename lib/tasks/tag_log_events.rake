namespace :add do
  task :tags => :environment do 
    # The following lines of code perform tagging based on a log events functionality
    LogEvent.ip_address("10.0.1.14").user_agent("WordPress/2.9.2; http://www.domain.org").all.each do |event|
      event.tag_list = "wordpress"
      event.save!
    end
    
    LogEvent.ip_address("10.0.1.2").user_agent("Apple-PubSub/65.12.1").all.each do |event|
      event.tag_list = "rss"
      event.save!
    end
    
    LogEvent.ip_address("10.0.1.2").user_agent("Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.3) Gecko/20100401 Firefox/3.6.3").all.each do |event|
      event.tag_list = "wordpress"
      event.save!
    end
    
    LogEvent.ip_address("10.0.1.2").user_agent("Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_2; en-us) AppleWebKit/531.22.7 (KHTML, like Gecko) Version/4.0.5 Safari/531.22.7").all.each do |event|
      event.tag_list = "wordpress"
      event.save!
    end
    
    LogEvent.ip_address("114.111.36.26").user_agent("Mozilla/4.0 (compatible; NaverBot/1.0; http://help.naver.com/customer_webtxt_02.jsp)").all.each do |event|
      event.tag_list = "bot"
      event.save!
    end
    
    LogEvent.ip_address("123.11.240.130").user_agent("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)").all.each do |event|
      event.tag_list = "proxy, scan"
      event.save!
    end
    
    LogEvent.ip_address("123.4.42.80").user_agent("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)").all.each do |event|
      event.tag_list = "proxy, scan"
      event.save!
    end
    
    LogEvent.ip_address("123.4.51.181").user_agent("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)").all.each do |event|
      event.tag_list = "proxy, scan"
      event.save!
    end
    
    LogEvent.ip_address("123.4.59.174").user_agent("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)").all.each do |event|
      event.tag_list = "proxy, scan"
      event.save!
    end
    
    LogEvent.ip_address("123.4.59.21").user_agent("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)").all.each do |event|
      event.tag_list = "proxy, scan"
      event.save!
    end
    
    LogEvent.ip_address("125.45.106.168").user_agent("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)").all.each do |event|
      event.tag_list = "proxy, scan"
      event.save!
    end
    
    LogEvent.ip_address("125.45.106.180").user_agent("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)").all.each do |event|
      event.tag_list = "proxy, scan"
      event.save!
    end
    
    LogEvent.ip_address("190.166.87.164").user_agent("Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/532.5 (KHTML, like Gecko) Chrome/4.1.249.1059 Safari/532.5").all.each do |event|
      event.tag_list = "wordpress"
      event.save!
    end
    
    LogEvent.ip_address("190.167.70.87").user_agent("Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/532.5 (KHTML, like Gecko) Chrome/4.1.249.1045 Safari/532.5").all.each do |event|
      event.tag_list = "wordpress"
      event.save!
    end
    
    LogEvent.ip_address("193.109.122.15").user_agent("-").all.each do |event|
      event.tag_list = "6677, scan"
      event.save!
    end
    
    LogEvent.ip_address("193.109.122.18").user_agent("-").all.each do |event|
      event.tag_list = "6677, scan"
      event.save!
    end
    
    LogEvent.ip_address("93.109.122.33").user_agent("-").all.each do |event|
      event.tag_list = "proxy, scan"
      event.save!
    end
    
    LogEvent.ip_address("193.109.122.52").user_agent("pxyscand/2.1").all.each do |event|
      event.tag_list = "6677, scan"
      event.save!
    end
    
    LogEvent.ip_address("193.109.122.56").user_agent("pxyscand/2.1").all.each do |event|
      event.tag_list = "6677, scan"
      event.save!
    end
    
    LogEvent.ip_address("193.109.122.57").user_agent("pxyscand/2.1").all.each do |event|
      event.tag_list = "6677, scan"
      event.save!
    end
    
    LogEvent.ip_address("201.229.176.217").user_agent("Mozilla/5.0 (Windows; U; Windows NT 5.1; es-ES; rv:1.9.0.19) Gecko/2010031422 Firefox/3.0.19").all.each do |event|
      event.tag_list = "wordpress"
      event.save!
    end
    
    LogEvent.ip_address("203.209.253.30").user_agent("iearthworm/1.0, iearthworm@yahoo.com.cn").all.each do |event|
      event.tag_list = "world-of-warcraft, scan"
      event.save!
    end
    
    LogEvent.ip_address("203.209.253.31").user_agent("iearthworm/1.0, iearthworm@yahoo.com.cn").all.each do |event|
      event.tag_list = "world-of-warcraft, scan"
      event.save!
    end
    
    LogEvent.ip_address("203.209.253.33").user_agent("iearthworm/1.0, iearthworm@yahoo.com.cn").all.each do |event|
      event.tag_list = "world-of-warcraft, scan"
      event.save!
    end
    
    LogEvent.ip_address("203.209.253.34").user_agent("iearthworm/1.0, iearthworm@yahoo.com.cn").all.each do |event|
      event.tag_list = "world-of-warcraft, scan"
      event.save!
    end
    
    LogEvent.ip_address("208.80.69.69").user_agent("Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_2; en-us) AppleWebKit/531.21.8 (KHTML, like Gecko) Version/4.0.4 Safari/531.21.10").all.each do |event|
      event.tag_list = "wordpress"
      event.save!
    end
    
    LogEvent.ip_address("208.80.69.74").user_agent("Apple-PubSub/65.12.1").all.each do |event|
      event.tag_list = "rss"
      event.save!
    end
    
    LogEvent.ip_address("221.192.199.35").user_agent("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0)").all.each do |event|
      event.tag_list = "proxy, scan"
      event.save!
    end
    
    LogEvent.ip_address("221.194.47.162").user_agent("-").all.each do |event|
      event.tag_list = "proxy, scan"
      event.save!
    end
    
    LogEvent.ip_address("61.183.15.9").user_agent("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0)").all.each do |event|
      event.tag_list = "proxy, scan"
      event.save!
    end
    
    LogEvent.ip_address("65.88.2.5").user_agent("Apple-PubSub/65.12.1").all.each do |event|
      event.tag_list = "rss"
      event.save!
    end
    
    LogEvent.ip_address("65.88.2.5").user_agent("Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.3) Gecko/20100401 Firefox/3.6.3").all.each do |event|
      event.tag_list = "wordpress"
      event.save!
    end
    
    LogEvent.ip_address("76.191.195.140").user_agent("Apple-PubSub/65.12.1").all.each do |event|
      event.tag_list = "rss"
      event.save!
    end
    
    LogEvent.ip_address("92.62.43.77").user_agent("-").all.each do |event|
      event.tag_list = "6667, scan"
      event.save!
    end
    
    LogEvent.ip_address("193.109.122.33").user_agent("-").all.each do |event|
      event.tag_list = "6677, scan"
      event.save!
    end
    
    # Following code tags log events associated with a WordPress plugin
    LogEvent.url("/wp-content/plugins").all.each do |event|
      event.tag_list << "wordpress"
      event.tag_list << "plugin"
      event.tag_list << "contact-form-7" if event.http[:uri] =~ /contact\-form\-7/
      event.tag_list << "google-syntax-highlighter" if event.http[:uri] =~ /google\-syntax\-highlighter/
      event.tag_list << "google-analyticator" if event.http[:uri] =~ /google\-analyticator/
      event.save!
    end
  end
end
