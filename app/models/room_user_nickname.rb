# frozen_string_literal: true
class RoomUserNickname < ActiveRecord::Base
  belongs_to :user
  belongs_to :room
end
