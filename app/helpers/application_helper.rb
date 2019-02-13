# frozen_string_literal: true
module ApplicationHelper
  def room_unread_messages(room)
    num = RoomUser.unread_message_count(room.id, current_or_guest_user.id)
    num.positive? ? num : 0
  end

  def flash_class(level)
    case level
    when 'notice' then 'alert alert-info'
    when 'success' then 'alert alert-success'
    when 'error' then 'alert alert-warning'
    when 'alert' then 'alert alert-danger'
    end
  end
end
