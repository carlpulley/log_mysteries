class CreateAuths < ActiveRecord::Migration
  def self.up
    create_table :auths do |t|
      t.datetime :observed_at
      t.string :host
      t.string :process
      t.integer :pid
      t.text :message
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :auths
  end
end
