class CreateApacheAccesses < ActiveRecord::Migration
  def self.up
    create_table :apache_accesses do |t|
      t.string :remote
      t.string :host
      t.string :user
      t.text :http
      t.integer :result
      t.integer :bytes
      t.string :referer
      t.string :user_agent
      t.string :unknown
      t.integer :processing_time
      t.datetime :observed_at

      t.timestamps
    end
  end

  def self.down
    drop_table :apache_accesses
  end
end
