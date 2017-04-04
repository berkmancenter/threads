# frozen_string_literal: true
module ApplicationHelper
  def room_unread_messages(room)
    item = RoomUser.room_user(room.id, current_user.id)
    item.present? ? item.unread_message_count : ''
  end
end
