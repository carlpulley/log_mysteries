class CreateArtefacts < ActiveRecord::Migration
  def self.up
    create_table :artefacts do |t|
      t.integer :entry_id
      t.string :path
      t.string :revision
      t.integer :size
      t.datetime :submitted_at
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :artefacts
  end
end
