class AddLockedToRooms < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :locked, :boolean, default: false
  end
end
