class CreateUsersNicknamesInRooms < ActiveRecord::Migration[5.0]
  def change
    create_table(:room_user_nicknames) do |t|
      t.belongs_to :room
      t.belongs_to :user
      t.string :nickname

      t.index %i[room_id nickname], unique: true
    end
  end
end
