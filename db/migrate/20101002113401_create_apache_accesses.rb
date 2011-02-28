class CreateApacheAccesses < ActiveRecord::Migration
  def self.up
    create_table :apache_accesses do |t|
      t.string :remote
      t.string :host
      t.string :user
      t.string :http_method
      t.string :http_url
      t.string :http_version
      t.integer :result
      t.integer :bytes
      t.string :referer
      t.string :user_agent
      t.string :unknown
      t.string :local
      t.integer :timestamp
      t.integer :pid
      t.integer :counter
      t.integer :thread_index
      t.integer :processing_time
      t.datetime :observed_at
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :apache_accesses
  end
end
