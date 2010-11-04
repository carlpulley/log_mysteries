class CreateIpAddresses < ActiveRecord::Migration
  def self.up
    create_table :ip_addresses do |t|
      t.string :value
      t.string :cc
      t.integer :asn
      t.string :bgp_prefix
      t.string :registry
      t.datetime :allocated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :ip_addresses
  end
end
