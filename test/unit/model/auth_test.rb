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

class AuthModelTest < ActiveSupport::TestCase
  context "Auth model" do
    setup do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations["development"])
      @events = Auth.scoped
    end
    
    should "have contents matching auth.log.sudo" do
      archive = "evidence/sanitized_log/auth.log.sudo"

      table_contents = []
      @events.find_each do |data|
        table_contents << data.to_s
      end
      table_contents << ""
      assert_equal "238b80fbfcca5feffd4df46bf4f544d493b8f07e", Digest::SHA1.hexdigest(table_contents.join("\n"))
    end
    
    should "have observed_at timestamps increasing with their position within auth.log" do
      assert SanitizedLog.where(:name => "sanitized_log/auth.log").first.observed_at >= @events.last.observed_at
      last_date = nil
      @events.find_each do |data|
        assert data.observed_at >= last_date unless last_date.nil?
        last_date = data.observed_at
      end
    end
  end
end
