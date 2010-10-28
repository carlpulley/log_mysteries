class CreateApacheErrors < ActiveRecord::Migration
  def self.up
    create_table :apache_errors do |t|
      t.datetime :observed_at
      t.string :level
      t.string :client
      t.string :message

      t.timestamps
    end
  end

  def self.down
    drop_table :apache_errors
  end
end
