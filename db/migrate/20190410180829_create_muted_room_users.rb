# frozen_string_literal: true
class CreateMutedRoomUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :muted_room_users do |t|
      t.belongs_to :room, null: false
      t.belongs_to :user, null: false
    end
  end
end
