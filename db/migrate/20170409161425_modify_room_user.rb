# frozen_string_literal: true
class ModifyRoomUser < ActiveRecord::Migration[5.0]
  def change
    remove_column :room_users, :unread_message_count
    add_index :room_users, :last_read_message_id
  end
end
