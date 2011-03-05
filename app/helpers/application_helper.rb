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
    attr_reader :data, :events
    
    def initialize
      @data = []
      @events = []
    end
    
    def add_event(label, scope)
      if block_given?
        @data << { :label => label, :timeline => scope.order(:observed_at).all.map { |d| { :begin => d.observed_at.to_f, :end => yield(d), :event_id => d.id, :event_type => d.class.table_name } } }
      else
        @data << { :label => label, :timeline => scope.order(:observed_at).all.map { |d| { :begin => d.observed_at.to_f, :end => d.observed_at.to_f, :event_id => d.id, :event_type => d.class.table_name } } }
      end
      @events.concat(scope.all).uniq
    end
    
    def events
      @events.sort { |a,b| a.observed_at.to_i <=> b.observed_at.to_i }
    end
  end
end
