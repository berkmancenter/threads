# frozen_string_literal: true
class RoomUser < ApplicationRecord
  belongs_to :user
  belongs_to :room
  belongs_to :last_read_message, class_name: 'Message', foreign_key: :last_read_message_id, optional: true

  def self.create_or_update!(room_id, user_id, last_read_message_id)
    item = find_by(room_id: room_id, user_id: user_id)
    if item.present?
      item.update_attributes(last_read_message_id: last_read_message_id)
    else
      create(room_id: room_id, user_id: user_id, last_read_message_id: last_read_message_id)
    end
  end

  def self.unread_message_count(room, user_id)
    item = find_by(room: room, user_id: user_id)
    if item.present?
      Message.unread_by_room_user(room.id, item&.last_read_message_id).size
    else
      room.messages.size
    end
  end

  def self.update_last_read_message!(room_id, user_id, last_read_message_id)
    item = find_by(room_id: room_id, user_id: user_id)
    item.update_attributes(last_read_message_id: last_read_message_id) if item.present?
  end
end
