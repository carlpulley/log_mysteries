#    <one line to give the program's name and a brief idea of what it does.>
#    Copyright (C) 2010  Carl J. Pulley
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

class WwwErrorTest < ActiveSupport::TestCase
  context "www-error.log" do
    setup do
      @www_error = "evidence/sanitized_log/apache2/www-error.log"
    end
    
    should "be extracted" do
      assert FileTest.file?(@www_error)
    end
    
    should "have a valid SHA1" do
      assert_equal "ba135fe6ba2d61b3887925ba0461072c17a4edd3", Digest::SHA1.hexdigest(open(@www_error, "r").read)
    end
    
    should "have the correct file type" do
      assert_match "ASCII text", `file #{@www_error}`
    end
  end
end
