require 'test_helper'

class ReportTest < ActionController::IntegrationTest
  context "Using development DB" do
    setup do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations["development"])
    end
  
    context "report-google-analyticator.csv" do
      should "should be a CSV file and have a valid SHA1" do
        get '/research/by.csv?tagged=google-analyticator'
        assert_equal "text/csv", @response.content_type
        assert_equal "4941a9d43d99a2d0077da43fba34f731754f438e", Digest::SHA1.hexdigest(@response.body)
      end
    end
  end
end