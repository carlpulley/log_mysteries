class AddApacheAccesFkToArchiveContent < ActiveRecord::Migration
  def self.up
    add_column :apache_accesses, :archive_content_id, :integer
  end

  def self.down
    remove_column :apache_accesses, :archive_content_id
  end
end
