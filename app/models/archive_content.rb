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

class ArchiveContent < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  
  acts_as_taggable_on :tags

  has_many :apache_accesses
  
  def to_s
    "#{observed_at.in_time_zone('Pacific Time (US & Canada)').strftime("%d/%b/%Y %H:%M:%S %z")} #{name} #{number_to_human_size(size)}"
  end
end
