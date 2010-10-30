require 'test_helper'

class IpAddressTest < ActionController::IntegrationTest
  context "Using development DB" do
    setup do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations["development"])
    end
    
    context "ip_address.csv" do
      should "be a CSV file and have a valid SHA1" do
        get '/research/ip_address.csv'
        assert_equal "text/csv", @response.content_type
        assert_equal "44238d56d999ea601ab98225fe713f502f30222a", Digest::SHA1.hexdigest(@response.body)
      end
    end
  end
end