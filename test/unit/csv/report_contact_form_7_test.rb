require 'test_helper'

class ReportTest < ActionController::IntegrationTest
  context "Using development DB" do
    setup do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations["development"])
    end
  
    context "report-contact-form-7.csv" do
      should "should be a CSV file and have a valid SHA1" do
        get '/research/by.csv?tagged=contact-form-7'
        assert_equal "text/csv", @response.content_type
        assert_equal "15d7a3f12046b24296005e64ecf73ad3428a01de", Digest::SHA1.hexdigest(@response.body)
      end
    end
  end
end