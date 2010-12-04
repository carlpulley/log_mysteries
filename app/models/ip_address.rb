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

class IpAddress < ActiveRecord::Base
  has_many :blacklists
  has_many :apache_accesses
  has_many :apache_errors
  
  def before_create
    asn_lookup
  end
  
  validates_presence_of :value
  validates_format_of :value, :with => /^\d+\.\d+\.\d+\.\d+$/
  
  private
  
  def asn_lookup
    result = `dig +short #{self.value.split(".").reverse.join(".")}.origin.asn.cymru.com TXT`
    unless result == ""
      result = result.split('|').map { |d| d.strip }
      self.asn = result[0][1..-1].to_i
      self.bgp_prefix = result[1]
      self.cc = result[2]
      self.registry = result[3]
      self.allocated_at = DateTime.strptime(result[4][0..-2], "%Y-%m-%d")
    end
  end
  
end
