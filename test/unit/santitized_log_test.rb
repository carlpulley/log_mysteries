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

class SanitizedLogTest < ActiveSupport::TestCase
  context "sanitized_log.zip" do
    setup do
      @sanitized_log = "evidence/sanitized_log.zip"
    end
    
    should "be downloaded" do
      assert FileTest.file?(@sanitized_log)
    end
    
    should "have a valid SHA1" do
      assert_equal "5d317ecf8147cafc0239166e47139afea3200c5b", Digest::SHA1.hexdigest(open(@sanitized_log, "r").read)
    end
    
    should "have the correct file type" do
      assert_match "Zip archive data", `file #{@sanitized_log}`
    end
  end
end
