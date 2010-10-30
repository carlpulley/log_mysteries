require 'test_helper'

class ReportTest < ActionController::IntegrationTest
  context "Using development DB" do
    setup do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations["development"])
    end
  
    context "report-easy-google-syntax-highlighter.csv" do
      should "should be a CSV file and have a valid SHA1" do
        get '/research/by.csv?tagged=easy-google-syntax-highlighter'
        assert_equal "text/csv", @response.content_type
        assert_equal "88ed61d9be80f56aece83bd56d74f67ab9aada0e", Digest::SHA1.hexdigest(@response.body)
      end
    end
  end
end