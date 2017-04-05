# frozen_string_literal: true
# == Schema Information
#
# Table name: room_users
#
#  id                   :integer          not null, primary key
#  user_id              :integer          not null
#  room_id              :integer          not null
#  last_read_message_id :integer
#  unread_message_count :integer          default(0)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class RoomUser < ApplicationRecord
  belongs_to :user
  belongs_to :room
  belongs_to :last_read_message, class_name: Message, foreign_key: :last_read_message_id, optional: true

  def self.create_or_update!(room_id, user_id, last_read_message_id)
    item = find_by(room_id: room_id, user_id: user_id)
    if item.present?
      item.update_attributes(last_read_message_id: last_read_message_id)
    else
      create(room_id: room_id, user_id: user_id, last_read_message_id: last_read_message_id)
    end
  end

  def self.unread_message_count(room_id, user_id)
    item = find_by(room_id: room_id, user_id: user_id)
    item.present? ? Message.unread_by_room_user(room_id, item&.last_read_message_id).size : 0
  end

  def self.update_last_read_message!(room_id, user_id, last_read_message_id)
    item = find_by(room_id: room_id, user_id: user_id)
    item.update_attributes(last_read_message_id: last_read_message_id) if item.present?
  end
end
