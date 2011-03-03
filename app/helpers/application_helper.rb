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

module ApplicationHelper  
  class Timeline
    attr_reader :data, :events, :max_bytes, :max_processing_time
    
    def initialize
      @data = []
      @events = []
      @max_bytes = 0
      @max_processing_time = 0
    end
    
    def add_event(label, scope)
      if scope.first.respond_to? :processing_time
        @data << { :label => label, :timeline => scope.order(:observed_at).all.map { |d| { :begin => d.observed_at.to_f, :end => d.observed_at.to_f+(d.processing_time.to_f/(10**6)), :event_id => d.id, :event_type => d.class.table_name } } }
      else
        @data << { :label => label, :timeline => scope.order(:observed_at).all.map { |d| { :begin => d.observed_at.to_f, :end => d.observed_at.to_f, :event_id => d.id, :event_type => d.class.table_name } } }
      end
      @max_bytes = (scope.all.map { |d| d.bytes } + [@max_bytes]).max if scope.first.respond_to? :bytes
      @max_processing_time = (scope.all.map { |d| d.processing_time } + [@max_processing_time]).max if scope.first.respond_to? :processing_time
      @events.concat(scope.all).uniq
    end
    
    def events
      @events.sort { |a,b| a.observed_at.to_i <=> b.observed_at.to_i }
    end
  end
end
