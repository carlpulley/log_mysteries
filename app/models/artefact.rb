class Artefact < ActiveRecord::Base
  belongs_to :entry
  
  validates_presence_of :path, :size, :submitted_at, :revision
  validates_uniqueness_of :path, :scope => :entry_id
  validates_numericality_of :size, :greater_than_or_equal_to => 0
end
