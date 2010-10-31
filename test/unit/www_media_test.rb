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

class WwwMediaTest < ActiveSupport::TestCase
  context "www-media.log" do
    setup do
      @www_media = "evidence/sanitized_log/apache2/www-media.log"
    end
    
    should "be extracted" do
      assert FileTest.file?(@www_media)
    end
    
    should "have a valid SHA1" do
      assert_equal "ee9a42f31d27e388b61c7fc971c78b2895f22142", Digest::SHA1.hexdigest(open(@www_media, "r").read)
    end
    
    should "have the correct file type" do
      assert_match "ASCII text", `file #{@www_media}`
    end
  end
end
