require 'test_helper'

class ReportTest < ActionController::IntegrationTest
  context "Using development DB" do
    setup do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations["development"])
    end
    
    context "report-wordpress.csv" do
      should "be a CSV file and have a valid SHA1" do
        get '/research/by.csv?tagged=wordpress'
        assert_equal "text/csv", @response.content_type
        assert_equal "5981a3113e586197eba0130b81e40d43fa4dee38", Digest::SHA1.hexdigest(@response.body)
      end
    end
  end
end