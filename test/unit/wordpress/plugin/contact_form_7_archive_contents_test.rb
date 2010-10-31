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

class ContactForm7ArchiveContentsTest < ActiveSupport::TestCase
  context "ApacheAccess model" do
    setup do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations["development"])
    end
    
    should "be consistent with contact-form-7 tagged entries in LogEvent that exist on the server" do
      ["contact-form-7/styles.css", "contact-form-7/scripts.js"].each do |filename|
        events = ApacheAccess.tagged_with("contact-form-7").url("/wp-content/plugins/#{filename}").where(:result => 200).get
        assert events.exists?
        events.all.each do |event|
          zip_items = ContactForm7.where(:name => filename)
          assert_equal 1, zip_items.count
          assert_equal zip_items.first.size, event.bytes
        end
      end
    end
  end
end
