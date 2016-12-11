# frozen_string_literal: true
# == Schema Information
#
# Table name: rooms
#
#  id           :integer          not null, primary key
#  owner_id     :integer          not null
#  room_icon_id :integer
#  title        :text             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Room < ApplicationRecord
  belongs_to :owner, class_name: User, foreign_key: :owner_id
  has_many :messages
  has_many :users, through: :messages

  validates :title, presence: true, length: { maximum: 1000 }
end
