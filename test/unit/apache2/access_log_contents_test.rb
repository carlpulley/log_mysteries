require 'test_helper'

class AccessLogContentsTest < ActiveSupport::TestCase
  context "ApacheAccess model" do
    setup do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations["development"])
    end
    
    context "and www-access.log" do
      setup do
        @events = ApacheAccess.where(:name => "www-access.log")
      end
      
      should "have matching contents" do
        table_contents = []
        @events.find_each do |data|
          table_contents << data.to_s
        end
        table_contents << ""
        assert_equal "a5e7274843bbf4a617bbdc557425d43b7b4508c2", Digest::SHA1.hexdigest(table_contents.join("\n"))
      end
      
      should "have observed_at timestamps increasing with their position within www-access.log" do
        assert SanitizedLog.where(:name => "sanitized_log/apache2/www-access.log").first.observed_at >= @events.last.observed_at
        last_date = nil
        @events.where(["id not in (?)", [145, 259, 297]]).find_each do |data|
          assert data.observed_at >= last_date unless last_date.nil?
          last_date = data.observed_at
        end
      end
    end
    
    context "and www-media.log" do
      setup do
        @events = ApacheAccess.where(:name => "www-media.log")
      end
      
      should "have matching contents" do
        table_contents = []
        @events.find_each do |data|
          table_contents << data.to_s
        end
        table_contents << ""
        assert_equal "ee9a42f31d27e388b61c7fc971c78b2895f22142", Digest::SHA1.hexdigest(table_contents.join("\n"))
      end
      
      should "have observed_at timestamps increasing with their position within www-media.log" do
        assert SanitizedLog.where(:name => "sanitized_log/apache2/www-media.log").first.observed_at >= @events.last.observed_at
        last_date = nil
        @events.where(["id not in (?)", [375, 393, 461, 467, 485, 570, 583, 585, 587, 588, 589]]).find_each do |data|
          assert data.observed_at >= last_date unless last_date.nil?
          last_date = data.observed_at
        end
      end
    end
  end
end
