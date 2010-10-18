class AddPageResourcesToLogEvents < ActiveRecord::Migration
  def self.up
    add_column :log_events, :parent_id, :integer
    add_column :log_events, :lft, :integer
    add_column :log_events, :rgt, :integer
    add_column :log_events, :depth, :integer
  end

  def self.down
    remove_column :log_events, :parent_id
    remove_column :log_events, :lft
    remove_column :log_events, :rgt
    remove_column :log_events, :depth
  end
end
