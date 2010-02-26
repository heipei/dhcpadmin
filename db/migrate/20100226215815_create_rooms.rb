class CreateRooms < ActiveRecord::Migration
  def self.up
    create_table :rooms do |t|
      t.string :dns,	:null => false
      t.string :ip,	:null => false
      t.integer :machine_id

      t.timestamps
    end
  end

  def self.down
    drop_table :rooms
  end
end
