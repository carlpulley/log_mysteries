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

class PackageTest < ActiveSupport::TestCase
  context "Sudo model" do
    setup do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations["development"])
    end
    
    should "have correct tagging of Sudo instances with package tagging names" do
      package_list = Sudo.package_counts.order(:name).map { |t| [t.name, t.taggings.order(:id).map { |ts| ts.taggable.to_s }] }
      assert_equal "802968502f0837fe69ee93031cadd33e2a99de6d", Digest::SHA1.hexdigest(package_list.to_s)
    end
  end
end
