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
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  has_many :messages, dependent: :destroy
  has_many :users, through: :messages
  has_many :room_user_nicknames, dependent: :destroy
  belongs_to :instance
  has_many :muted_room_users, dependent: :destroy

  validates :title, presence: true, length: { maximum: 1000 }
  validates :instance, presence: true
end
