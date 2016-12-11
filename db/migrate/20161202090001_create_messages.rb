# frozen_string_literal: true
class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages, id: false do |t|
      t.column  :id, :primary_key, unsigned: true, null: false
      t.integer :room_id,                unsigned: true, null: false
      t.integer :user_id,                unsigned: true, null: false
      t.text    :content,                                null: false

      t.timestamps null: false
    end

    add_index :messages, :room_id
    add_index :messages, :user_id
  end
end
