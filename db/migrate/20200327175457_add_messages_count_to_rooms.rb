class AddMessagesCountToRooms < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :messages_count, :integer
    Room.find_each do |room|
      Room.reset_counters(room.id, :messages)
    end
  end
end
