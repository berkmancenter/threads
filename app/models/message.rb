# frozen_string_literal: true
class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :content, presence: true, length: { maximum: 4000 }

  scope :unread_by_room_user, ->(room_id, last_read_message_id) {
    query = where(room_id: room_id)
    query = query.where('id > ?', last_read_message_id) if last_read_message_id
    query
  }

  def author
    user.username
  end
end
