namespace :tag do
  namespace :events do
    task :bot => :environment do 
      ApacheAccess.ip_address("114.111.36.26").user_agent("Mozilla/4.0 (compatible; NaverBot/1.0; http://help.naver.com/customer_webtxt_02.jsp)").all.each do |event|
        event.tag_list = "bot"
        event.save!
      end
    end
  end
end