class CreateBlacklists < ActiveRecord::Migration
  def self.up
    create_table :blacklists do |t|
      t.integer :ip_address_id
      t.integer :web_page_id
      t.string :site
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :blacklists
  end
end
