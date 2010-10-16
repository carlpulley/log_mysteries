class AddFileObjectFkToLogEvents < ActiveRecord::Migration
  def self.up
    add_column :log_events, :file_object_id, :integer
  end

  def self.down
    remove_column :log_events, :file_object_id
  end
end
