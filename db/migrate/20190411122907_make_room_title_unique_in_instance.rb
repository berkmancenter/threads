class MakeRoomTitleUniqueInInstance < ActiveRecord::Migration[5.2]
  def change
    add_index :rooms, %i[title instance_id], unique: true
  end
end
