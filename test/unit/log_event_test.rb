require 'test_helper'

class LogEventTest < ActiveSupport::TestCase
  context "ApacheAccess model" do
    setup do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations["development"])
    end
        
    context "non-empty unknown attribute" do
      setup do
        @events = ApacheAccess.where("unknown != '-'").all
      end
      
      should "have timestamp match (+/- 1 second) to a truncated value of observed_at (except for event 394)" do
        @events.each do |event|
          unless event.id == 394
            assert_in_delta ((event.observed_at.to_i * (10**6)) % (256**4)) / (10**6), event.timestamp, 1, "event ID = #{event.id}"
          end
        end
      end
    end
  end
end
