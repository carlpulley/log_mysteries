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
end
