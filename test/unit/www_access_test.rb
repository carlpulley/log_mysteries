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
  context "www-access.log" do
    setup do
      @www_access = "evidence/sanitized_log/apache2/www-access.log"
    end
    
    should "be extracted" do
      assert FileTest.file?(@www_access)
    end
    
    should "have a valid SHA1" do
      assert_equal "a5e7274843bbf4a617bbdc557425d43b7b4508c2", Digest::SHA1.hexdigest(open(@www_access, "r").read)
    end
    
    should "have the correct file type" do
      assert_match "ASCII text", `file #{@www_access}`
    end
  end
end
