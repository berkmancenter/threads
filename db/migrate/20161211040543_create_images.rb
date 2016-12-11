# frozen_string_literal: true
class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images, id: false do |t|
      t.column  :id, :primary_key, unsigned: true, null: false
      t.string  :file,                                null: false
      t.string  :name,                                null: false
      t.integer :size,                                null: false
      t.string  :content_type,                        null: false
      t.string  :digest,                              null: false

      t.timestamps null: false
    end

    add_index :images, :digest, unique: true
  end
end
