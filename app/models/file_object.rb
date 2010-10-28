class FileObject < ActiveRecord::Base
  acts_as_nested_set
  has_many :apache_accesses
  
  validates_presence_of :name
end
