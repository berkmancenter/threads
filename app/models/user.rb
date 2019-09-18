# frozen_string_literal: true
require 'faker'

class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A([^@\s]{1,64})@((?:[-\p{L}\d]+\.)+\p{L}{2,})\z/i

  before_create :set_default_role

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :messages, dependent: :destroy
  has_many :rooms, through: :messages
  has_and_belongs_to_many :roles
  has_many :room_user_nicknames, dependent: :destroy
  has_many :moderatorships, dependent: :destroy
  has_many :muted_room_users, dependent: :destroy

  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 64 }
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }

  def role?(role)
    roles.include?(role)
  end

  def nickname_in_room(room)
    return 'OP' if room.owner_id == id
    return ENV['VICTORIOUSBORN_NICKNAME'] if ENV['VICTORIOUSBORN_NICKNAME'].present? && username == 'victoriousBorn'

    nickname_in_room = RoomUserNickname.where(
      room: room,
      user: self
    ).first

    return nickname_in_room.nickname unless nickname_in_room.nil?

    nickname_in_room = loop do
      nickname = [
        Faker::Space.planet,
        Faker::Space.moon,
        Faker::Space.galaxy,
        Faker::Space.star,
        Faker::TvShows::Stargate.planet,
        Faker::Movies::StarWars.planet,
        Faker::Games::Witcher.location
      ].sample

      break RoomUserNickname.create!(
        user: self,
        nickname: nickname,
        room: room
      ) unless RoomUserNickname.exists?(
        room: room,
        nickname: nickname
      )
    end

    nickname_in_room.nickname
  end

  def muted_in_room?(room)
    MutedRoomUser.where(room: room, user: self).any?
  end

  private

  def set_default_role
    unless roles.include?(Role.anonymous)
      roles << Role.registered
    end
  end
end
