class FileObject < ActiveRecord::Base
  acts_as_nested_set
  has_many :log_events
  
  validates_presence_of :name
end
