#    Log Mysteries: partial answer for Honeynet challenge
#    Reference: http://honeynet.org/challenges/2010_5_log_mysteries
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

class ReportTest < ActionController::IntegrationTest
  context "Using development DB" do
    setup do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations["development"])
    end
  
    context "report-contact-form-7.csv" do
      should "should be a CSV file and have a valid SHA1" do
        get '/research/wordpress/plugin/contact-form-7.csv'
        assert_equal "text/csv", @response.content_type
        assert_equal "15d7a3f12046b24296005e64ecf73ad3428a01de", Digest::SHA1.hexdigest(@response.body)
      end
    end
  end
end