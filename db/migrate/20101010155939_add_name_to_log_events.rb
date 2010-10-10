class AddNameToLogEvents < ActiveRecord::Migration
  def self.up
    add_column :log_events, :name, :string
  end

  def self.down
    remove_column :log_events, :name
  end
end
