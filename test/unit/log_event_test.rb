require 'test_helper'

class SanitizedLogTest < ActiveSupport::TestCase
  context "LogEvent model" do
    setup do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations["development"])
    end
    
    context "www-access.log" do
      setup do
        @events = LogEvent.where(:name => "www-access.log")
      end
      
      should "have contents matching www-access.log" do
        table_contents = []
        @events.find_each do |data|
          table_contents << data.to_s
        end
        table_contents << ""
        assert_equal "a5e7274843bbf4a617bbdc557425d43b7b4508c2", Digest::SHA1.hexdigest(table_contents.join("\n"))
      end
      
      should "have created_at timestamps increasing with their position within www-access.log" do
        assert File.stat("evidence/sanitized_log/apache2/www-access.log").mtime >= LogEvent.last.created_at
        last_date = nil
        items = []
        @events.find_each do |data|
          unless last_date.nil?
            unless data.created_at >= last_date
              items << [data, last_date]
            end
          end
          last_date = data.created_at
        end
        assert_equal [], items
      end
    end
    
    context "www-media.log" do
      setup do
        @events = LogEvent.where(:name => "www-media.log")
      end
      
      should "have contents matching www-media.log" do
        table_contents = []
        @events.find_each do |data|
          table_contents << data.to_s
        end
        table_contents << ""
        assert_equal "ee9a42f31d27e388b61c7fc971c78b2895f22142", Digest::SHA1.hexdigest(table_contents.join("\n"))
      end
      
      should "have created_at timestamps increasing with their position within www-media.log" do
        assert File.stat("evidence/sanitized_log/apache2/www-media.log").mtime >= LogEvent.last.created_at
        last_date = nil
        items = []
        @events.find_each do |data|
          unless last_date.nil?
            unless data.created_at >= last_date
              items << [data, last_date]
            end
          end
          last_date = data.created_at
        end
        assert_equal [], items
      end
    end
  end
end
