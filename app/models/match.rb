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

class Match < ActiveRecord::Base
  acts_as_taggable_on :tags
  
  scope :file, lambda { includes(:archive_content).where('archive_contents.directory' => false) }
  scope :type, lambda { |nm| joins([:archive_content, {:apache_access => {:taggings => :tag}}]).where('tags.name' => (nm == "easy-google-syntax-highlighter" ? "google-syntax-highlighter" : nm), 'archive_contents.type' => nm.titleize.split(" ").join("")) }
  
  belongs_to :archive_content
  belongs_to :apache_access
end
