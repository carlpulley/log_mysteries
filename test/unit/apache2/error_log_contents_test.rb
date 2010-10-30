require 'test_helper'

class ErrorLogContentsTest < ActiveSupport::TestCase
  context "ApacheError model" do
    setup do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations["development"])
      @events = ApacheError.scoped
    end
    
    should "have contents matching www-error.log" do
      table_contents = []
      @events.find_each do |data|
        table_contents << data.to_s
      end
      table_contents << ""
      assert_equal "ba135fe6ba2d61b3887925ba0461072c17a4edd3", Digest::SHA1.hexdigest(table_contents.join("\n"))
    end
    
    should "have observed_at timestamps increasing with their position within www-error.log" do
      assert SanitizedLog.where(:name => "sanitized_log/apache2/www-error.log").first.observed_at >= @events.last.observed_at
      last_date = nil
      @events.find_each do |data|
        assert data.observed_at >= last_date unless last_date.nil?
        last_date = data.observed_at
      end
    end
  end
end