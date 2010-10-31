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

class IpAddressTest < ActionController::IntegrationTest
  context "Using development DB" do
    setup do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations["development"])
    end
    
    context "ip_address.csv" do
      should "be a CSV file and have a valid SHA1" do
        get '/research/ip_address.csv'
        assert_equal "text/csv", @response.content_type
        assert_equal "44238d56d999ea601ab98225fe713f502f30222a", Digest::SHA1.hexdigest(@response.body)
      end
    end
  end
end