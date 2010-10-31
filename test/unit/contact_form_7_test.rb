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

class ContactForm7Test < ActiveSupport::TestCase
  context "contact-form-7.2.1.1.zip" do
    setup do
      @contact_form = "evidence/contact-form-7.2.1.1.zip"
    end
    
    should "be downloaded" do
      assert FileTest.file?(@contact_form)
    end
    
    should "have a valid SHA1" do
      assert_equal "6edbf0506304a1eaf1c03e4a47ad1bcb462e04f2", Digest::SHA1.hexdigest(open(@contact_form, "r").read)
    end
    
    should "have the correct file type" do
      assert_match "Zip archive data", `file #{@contact_form}`
    end
  end
end
