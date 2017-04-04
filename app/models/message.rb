# frozen_string_literal: true
# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  room_id    :integer          not null
#  user_id    :integer          not null
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :content, presence: true, length: { maximum: 4000 }

  scope :ordered, -> { order(id: :asc) }
end
