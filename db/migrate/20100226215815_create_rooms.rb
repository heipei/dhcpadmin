class CreateRooms < ActiveRecord::Migration
  def self.up
    create_table :rooms do |t|
      t.string :dns,	:null => false
      t.string :ip,	:null => false
      t.string :mac,	:null => false, :default => "00:00:00:00:00:2f"
      t.string :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :rooms
  end
end
