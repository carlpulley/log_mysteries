class CreateLogEvents < ActiveRecord::Migration
  def self.up
    create_table :log_events do |t|
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

      t.timestamps
    end
  end

  def self.down
    drop_table :log_events
  end
end
