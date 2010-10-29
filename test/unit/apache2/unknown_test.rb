require 'test_helper'

class UnknownTest < ActiveSupport::TestCase
  context "ApacheAccess model" do
    setup do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations["development"])
    end
        
    context "non-empty unknown attribute" do
      setup do
        @events = ApacheAccess.where("unknown != '-'")
        @anomalies = [394]
      end
      
      should "have timestamp match (+/- 1 second) to a truncated value of observed_at" do
        @events.where(["id not in (?)", @anomalies]).find_each do |event|
          assert_in_delta ((event.observed_at.to_i * (10**6)) % (256**4)) / (10**6), event.timestamp, 1, "event ID = #{event.id}"
        end
      end
      
      should "have anomalies failing to match timestamp" do
        @anomalies.map { |n| ApacheAccess.find(n) }.each do |event|
          assert_not_in_delta ((event.observed_at.to_i * (10**6)) % (256**4)) / (10**6), event.timestamp, 1
        end
      end
    end
  end
end
