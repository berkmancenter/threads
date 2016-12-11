# frozen_string_literal: true
class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users, id: false do |t|
      t.column  :id,       :primary_key, unsigned: true, null: false
      t.integer :avatar_id,              unsigned: true
      t.string  :username, null: false
    end

    add_index :users, :username, unique: true
    add_index :users, :avatar_id
  end
end
