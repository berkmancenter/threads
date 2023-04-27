# frozen_string_literal: true
class AddPlannedLockToRooms < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :planned_lock, :datetime
  end
end
