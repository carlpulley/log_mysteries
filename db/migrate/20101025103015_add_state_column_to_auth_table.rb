class AddStateColumnToAuthTable < ActiveRecord::Migration
  def self.up
    add_column :auths, :state, :string
  end

  def self.down
    remove_column :auths, :state
  end
end
