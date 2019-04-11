module RoomsHelper
  def last_update_info(room)
    latest_message = room.messages.first

    if latest_message && latest_message.created_at > (Time.now - 24.hours)
      "| updated #{time_ago_in_words(latest_message.created_at)} ago"
    end
  end
end
