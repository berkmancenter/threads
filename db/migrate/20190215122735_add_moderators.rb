class AddModerators < ActiveRecord::Migration[5.0]
  def change
    create_table(:moderatorships) do |t|
      t.belongs_to :instance
      t.belongs_to :user
    end
  end
end
