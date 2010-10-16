class CreateFileObjects < ActiveRecord::Migration
  def self.up
    create_table :file_objects do |t|
      t.string :name
      t.integer :lft
      t.integer :rgt
      t.integer :parent_id
      t.integer :depth

      t.timestamps
    end
  end

  def self.down
    drop_table :file_objects
  end
end
