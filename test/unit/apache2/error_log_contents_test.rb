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

class ErrorLogContentsTest < ActiveSupport::TestCase
  context "ApacheError model" do
    setup do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations["development"])
      @events = ApacheError.scoped
    end
    
    should "have contents matching www-error.log" do
      table_contents = []
      @events.find_each do |data|
        table_contents << data.to_s
      end
      table_contents << ""
      assert_equal "ba135fe6ba2d61b3887925ba0461072c17a4edd3", Digest::SHA1.hexdigest(table_contents.join("\n"))
    end
    
    should "have observed_at timestamps increasing with their position within www-error.log" do
      assert SanitizedLog.where(:name => "sanitized_log/apache2/www-error.log").first.observed_at >= @events.last.observed_at
      last_date = nil
      @events.find_each do |data|
        assert data.observed_at >= last_date unless last_date.nil?
        last_date = data.observed_at
      end
    end
  end
end
