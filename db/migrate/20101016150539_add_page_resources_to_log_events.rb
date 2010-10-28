class AddPageResourcesToLogEvents < ActiveRecord::Migration
  def self.up
    add_column :apache_accesses, :parent_id, :integer
    add_column :apache_accesses, :lft, :integer
    add_column :apache_accesses, :rgt, :integer
    add_column :apache_accesses, :depth, :integer
  end

  def self.down
    remove_column :apache_accesses, :parent_id
    remove_column :apache_accesses, :lft
    remove_column :apache_accesses, :rgt
    remove_column :apache_accesses, :depth
  end
end
