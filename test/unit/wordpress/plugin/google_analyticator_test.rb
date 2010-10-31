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

class GoogleAnalyticatorContentsTest < ActiveSupport::TestCase
  context "google-analyticator.6.0.2.zip" do
    setup do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations["development"])
    end
    
    should "be consistent with google-analyticator tagged entries in ApacheAccess that exist on the server" do
      ["google-analyticator/external-tracking.min.js"].each do |filename|
        events = ApacheAccess.tagged_with("google-analyticator").url("/wp-content/plugins/#{filename}").where(:result => 200).get
        assert events.exists?
        events.all.each do |event|
          zip_items = GoogleAnalyticator.where(:name => filename)
          assert_equal 1, zip_items.count
          assert_equal zip_items.first.size, event.bytes
        end
      end
    end
  end
end
