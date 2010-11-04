class CreateWebPages < ActiveRecord::Migration
  def self.up
    create_table :web_pages do |t|
      t.string :url
      t.text :page

      t.timestamps
    end
  end

  def self.down
    drop_table :web_pages
  end
end
