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
      if scope.first.respond_to? :processing_time
        @data << { :label => label, :timeline => scope.order(:observed_at).all.map { |d| { :begin => d.observed_at.to_f, :end => d.observed_at.to_f+(d.processing_time.to_f/(10**6)), :event_id => d.id, :event_type => d.class.table_name } } }
      else
        @data << { :label => label, :timeline => scope.order(:observed_at).all.map { |d| { :begin => d.observed_at.to_f, :end => d.observed_at.to_f, :event_id => d.id, :event_type => d.class.table_name } } }
      end
      @events << scope.all.map { |d| { :observed_at => d.observed_at.to_f, :id => d.id, :type => d.class.table_name, :event => d.to_s } }
    end
    
    def events
      @events.inject([]) { |t,h| t+h }.uniq.sort { |a,b| a[:observed_at] <=> b[:observed_at] }
    end
  end

  def github_link(location, location_label = nil)
    location_label ||= location
    #link_to location_label, "http://github.com/carlpulley/log_mysteries/#{location}"
    link_to location_label, "file://#{File.expand_path('.')}/#{location}"
  end
  
  def display(testfile)
    case testfile
      when /csv\/.+?_test\.rb$/
        if File.exists?("test/unit/#{testfile}")
          return `cat test/unit/#{testfile}`
        else
          return "No integration test file exists!"
        end
      when /tag\/.+?_test\.rb$/
        if File.exists?("test/unit/#{testfile}")
          return `cat test/unit/#{testfile}`
        else
          return "No integration test file exists"
        end
      when /tag\/.+?\.rake$/
        if File.exists?("lib/tasks/#{testfile}")
          return `cat lib/tasks/#{testfile}`
        else
          return "No data carving rake task exists"
        end
    end
  end
end
