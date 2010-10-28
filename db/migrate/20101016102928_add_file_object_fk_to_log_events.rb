class AddFileObjectFkToLogEvents < ActiveRecord::Migration
  def self.up
    add_column :apache_accesses, :file_object_id, :integer
  end

  def self.down
    remove_column :apache_accesses, :file_object_id
  end
end
