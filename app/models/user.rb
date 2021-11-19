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

  scope :not_anonymous, -> { includes(:roles).where.not(roles_users: { role_id: Role.anonymous.id.to_s })}

  def role?(role)
    roles.include?(role)
  end

  def nickname_in_room(room)
    return 'OP' if room.owner_id == id
    return ENV['VICTORIOUSBORN_NICKNAME'] if ENV['VICTORIOUSBORN_NICKNAME'].present? && username == 'victoriousBorn'

    in_room_user_nicknames = RoomUserNickname.includes(:user).where(room: room)
    nickname_in_room = in_room_user_nicknames.find { |room_user_nickname| room_user_nickname.user == self }

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
    @muted_in_room_all ||= MutedRoomUser.includes(:user).where(room: room)
    @muted_in_room_all.find { |muted_in_room| muted_in_room.user == self }
                      .present?
  end

  private

  def set_default_role
    unless roles.include?(Role.anonymous)
      roles << Role.registered
    end
  end
end
