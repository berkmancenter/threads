module RoomsHelper
  def last_update_info(room)
    latest_message = room.messages.first

    if latest_message && latest_message.created_at > (Time.now - 24.hours)
      "| updated #{time_ago_in_words(latest_message.created_at)} ago"
    end
  end

  def room_unread_messages(room)
    num = RoomUser.unread_message_count(room, current_or_guest_user.id)
    num.positive? ? num : 0
  end
end
