#    Log Mysteries: partial answer for Honeynet challenge (see http://honeynet.org/challenges/2010_5_log_mysteries)
#    Copyright (C) 2010  Dr. Carl J. Pulley
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
