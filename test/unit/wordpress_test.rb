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

class WordpressTest < ActiveSupport::TestCase
  context "wordpress-2.9.2.tar.gz" do
    setup do
      @wordpress = "evidence/wordpress-2.9.2.tar.gz"
    end
    
    should "be downloaded" do
      assert FileTest.file?(@wordpress)
    end
    
    should "have a valid MD5" do
      assert_equal "6023fe6701476c8152bda5d4c6277c69", Digest::MD5.hexdigest(open(@wordpress, "r").read)
    end
    
    should "have the correct file type" do
      assert_match "gzip compressed data", `file #{@wordpress}`
    end
  end
end
