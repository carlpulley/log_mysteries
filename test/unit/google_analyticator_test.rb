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

class GoogleAnalyticatorTest < ActiveSupport::TestCase
  context "google-analyticator.6.0.2.zip" do
    setup do
      @auth = "evidence/google-analyticator.6.0.2.zip"
    end
    
    should "be extracted" do
      assert FileTest.file?(@auth)
    end
    
    should "have a valid SHA1" do
      assert_equal "67858ac2861e0be9332cee73240a8f8f814ece0c", Digest::SHA1.hexdigest(open(@auth, "r").read)
    end
    
    should "have the correct file type" do
      assert_match "Zip archive data", `file #{@auth}`
    end
  end
end
