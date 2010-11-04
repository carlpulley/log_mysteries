class AddFkToApache2Logs < ActiveRecord::Migration
  def self.up
    add_column :apache_accesses, :ip_address_id, :integer
    add_column :apache_errors, :ip_address_id, :integer
  end

  def self.down
    remove_column :apache_accesses, :ip_address_id
    remove_column :apache_errors, :ip_address_id
  end
end
