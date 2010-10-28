class AddNameToLogEvents < ActiveRecord::Migration
  def self.up
    add_column :apache_accesses, :name, :string
  end

  def self.down
    remove_column :apache_accesses, :name
  end
end
