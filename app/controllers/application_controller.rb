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

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected
  
  def asn_lookup(ip_address)
    result = `dig +short #{ip_address.split(".").reverse.join(".")}.origin.asn.cymru.com TXT`
    unless result == ""
      result = result.split('|').map { |d| d.strip }
      { :asn => result[0][1..-1].to_i, :bgp_prefix => result[1], :cc => result[2], :registry => result[3], :allocated_at => DateTime.strptime(result[4][0..-2], "%Y-%m-%d") }
    end
  end
end
