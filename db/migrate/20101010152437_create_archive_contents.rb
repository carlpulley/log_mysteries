class CreateArchiveContents < ActiveRecord::Migration
  def self.up
    create_table :archive_contents do |t|
      t.string :type
      t.string :archive
      t.string :name
      t.integer :size
      t.boolean :directory
      t.datetime :observed_at

      t.timestamps
    end
  end

  def self.down
    drop_table :archive_contents
  end
end
