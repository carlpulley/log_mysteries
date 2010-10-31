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

module ReportHelper
  def average(values)
    values.sum / values.count.to_f
  end
  
  def mean(values)
    count = values.size
    values.inject(:+) / count.to_f
  end
  
  def standard_deviation(values)
    Math.sqrt(values.inject(0) { |sum, e| sum + (e - mean(values))**2 } / values.size.to_f)
  end
  
  def github_link(location, location_label)
    location_label ||= location
    #link_to location_label, "http://github.com/carlpulley/log_mysteries/#{location}"
    link_to location_label, "file://#{File.expand_path('.')}/#{location}"
  end
end
