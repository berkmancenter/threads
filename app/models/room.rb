# frozen_string_literal: true
class Room < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  has_many :messages, dependent: :destroy
  has_many :users, through: :messages
  has_many :room_user_nicknames, dependent: :destroy
  belongs_to :instance, counter_cache: true
  has_many :muted_room_users, dependent: :destroy

  validates :title, presence: true, length: { maximum: 1000 }
  validates :instance, presence: true
  validates :title, uniqueness: { scope: :instance }
end
