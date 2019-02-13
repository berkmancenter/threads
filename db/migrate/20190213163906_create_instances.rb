class CreateInstances < ActiveRecord::Migration[5.0]
  def change
    create_table :instances, id: false do |t|
      t.column  :id,       :primary_key, unsigned: true, null: false
      t.integer :owner_id,               unsigned: true, null: false
      t.text    :title,                                  null: false
      t.boolean :closed,                                 null: false
      t.boolean :private,                                null: false

      t.timestamps null: false
    end

    add_index :instances, :owner_id

    add_column :rooms, :instance_id, :integer, references: 'instances'
    add_index :rooms, :instance_id
  end
end
