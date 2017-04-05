# frozen_string_literal: true
module ApplicationHelper
  def room_unread_messages(room)
    num = RoomUser.unread_message_count(room.id, current_user.id)
    num.positive? ? num : ''
  end
end
