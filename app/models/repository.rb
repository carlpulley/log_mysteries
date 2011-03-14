class Repository < ActiveRecord::Base
  has_one :trunk, :class_name => 'Entry', :foreign_key => 'repository_id', :dependent => :delete
  has_many :tags, :class_name => 'TagEntry', :foreign_key => 'repository_id', :dependent => :delete_all
  has_many :branches, :class_name => 'BranchEntry', :foreign_key => 'repository_id', :dependent => :delete_all
  
  validates_presence_of :name, :url
  validates_uniqueness_of :name, :url
  validates_associated :trunk
  validates_associated :tags
  validates_associated :branches
  
  def entries
    Entry.joins(:repository).where({:repository => self})
  end
  
  def artefacts
    Artefact.joins(:entry => :repository).where({:entry => {:repository => self}})
  end
end
