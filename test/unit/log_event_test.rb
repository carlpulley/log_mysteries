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
      
      should "have observed_at timestamps increasing with their position within www-access.log" do
        assert File.stat("evidence/sanitized_log/apache2/www-access.log").mtime >= LogEvent.last.observed_at
        last_date = nil
        @events.where("log_events.id not in (145, 259, 297)").find_each do |data|
          assert data.observed_at >= last_date unless last_date.nil?
          last_date = data.observed_at
        end
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
      
      should "have observed_at timestamps increasing with their position within www-media.log" do
        assert File.stat("evidence/sanitized_log/apache2/www-media.log").mtime >= LogEvent.last.observed_at
        last_date = nil
        @events.where("log_events.id not in (375, 393, 461, 467, 485, 570, 583, 585, 587, 588, 589)").find_each do |data|
          assert data.observed_at >= last_date, "id: #{data.id}" unless last_date.nil?
          last_date = data.observed_at
        end
      end
    end
    
    context "non-empty unknown attribute" do
      setup do
        @events = LogEvent.where("unknown != '-'").all
      end
      
      should "have no character ordinal values in range 58-63" do
        @events.each do |event|
          event.unknown.split("").each do |char|
            assert not((58..63).member?(char.ord))
          end
        end
      end
      
      should "have no character ordinal values in range 91-96" do
        @events.each do |event|
          event.unknown.split("").each do |char|
            assert not((91..96).member?(char.ord))
          end
        end
      end
      
      should "have no character ordinal values below 44" do
        @events.each do |event|
          event.unknown.split("").each do |char|
            assert char.ord > 44
          end
        end
      end
      
      should "have no character ordinal values above 123" do
        @events.each do |event|
          event.unknown.split("").each do |char|
            assert char.ord < 123
          end
        end
      end
    end
  end
end
