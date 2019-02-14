# frozen_string_literal: true
require 'faker'

class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A([^@\s]{1,64})@((?:[-\p{L}\d]+\.)+\p{L}{2,})\z/i

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  has_many :messages
  has_many :rooms, through: :messages
  has_and_belongs_to_many :roles
  has_many :room_user_nicknames, dependent: :destroy

  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 64 }
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }

  def role?(role)
    roles.include?(role)
  end

  def nickname_in_room(room)
    return 'OP' if room.owner_id == id

    nickname_in_room = RoomUserNickname.where(
      room: room,
      user: self
    ).first

    return nickname_in_room.nickname unless nickname_in_room.nil?

    nickname_in_room = loop do
      nickname = Faker::Superhero.name

      break RoomUserNickname.create!(
        user: self,
        nickname: nickname,
        room: room
      ) unless RoomUserNickname.exists?(
        room: room,
        nickname: Faker::Superhero.name
      )
    end

    nickname_in_room.nickname
  end
end
