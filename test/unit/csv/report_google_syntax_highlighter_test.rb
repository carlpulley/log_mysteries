require 'test_helper'

class ReportTest < ActionController::IntegrationTest
  context "Using development DB" do
    setup do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations["development"])
    end
  
    context "report-google-syntax-highlighter.csv" do
      should "should be a CSV file and have a valid SHA1" do
        get '/research/by.csv?tagged=google-syntax-highlighter'
        assert_equal "text/csv", @response.content_type
        assert_equal "ed4bfe34cfe12bd7023591650baa1541f94ff903", Digest::SHA1.hexdigest(@response.body)
      end
    end
  end
end