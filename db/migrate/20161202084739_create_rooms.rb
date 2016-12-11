# frozen_string_literal: true
class CreateRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :rooms, id: false do |t|
      t.column  :id,       :primary_key, unsigned: true, null: false
      t.integer :owner_id,               unsigned: true, null: false
      t.integer :room_icon_id,           unsigned: true
      t.text    :title,                                  null: false

      t.timestamps null: false
    end

    add_index :rooms, :owner_id
    add_index :rooms, :room_icon_id
  end
end
