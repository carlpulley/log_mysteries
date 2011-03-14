class Entry < ActiveRecord::Base
  belongs_to :repository
  has_many :artefacts
  
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :repository_id
  validates_associated :artefacts
end
