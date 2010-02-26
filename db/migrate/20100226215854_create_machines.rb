class CreateMachines < ActiveRecord::Migration
  def self.up
    create_table :machines do |t|
      t.string :mac,		:null => false
      t.string :comment,	:null => false
      t.string :creator, 	:null => false
      t.timestamp :valid_until

      t.timestamps
    end
  end

  def self.down
    drop_table :machines
  end
end
