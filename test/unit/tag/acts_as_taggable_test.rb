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

class ActsAsTaggableTest < ActiveSupport::TestCase
  context "ActsAsTaggableOn module" do
    setup do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations["development"])
    end
    
    should "have correct ActsAsTaggableOn::Tag members" do
      tag_list = ActsAsTaggableOn::Tag.all.to_xml
      assert_equal "d176e34520645cfbe7cff7ca72565edd741bb6e9", Digest::SHA1.hexdigest(tag_list.to_s)
    end
    
    should "have correct ActsAsTaggableOn::Tagging members" do
      tagging_list = ActsAsTaggableOn::Tagging.all.to_xml
      assert_equal "99a8e9fdc91bf274caefcf5bc81d91b9722da7b0", Digest::SHA1.hexdigest(tagging_list.to_s)
    end
  end
end
