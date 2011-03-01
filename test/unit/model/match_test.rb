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

class MatchTest < ActiveSupport::TestCase
  context "Match model" do
    setup do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations["development"])
    end
    
    should "have Match instances correctly pairing ApacheAccess and ArchiveContent instances" do
      matches = Match.order(:apache_accesses => :observed_at).all.map { |m| [m.apache_access.to_s, m.archive_content.to_s] }
      assert_equal "a79aec9514388c48e777ce13158dddffaed4e4cb", Digest::SHA1.hexdigest(matches.to_yaml)
    end
  end
end