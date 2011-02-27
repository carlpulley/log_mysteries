class CreateMatches < ActiveRecord::Migration
  def self.up
    create_table :matches do |t|
      t.integer :archive_content_id
      t.integer :apache_access_id

      t.timestamps
    end
  end

  def self.down
    drop_table :matches
  end
end