class AddRegisteredUserRole < ActiveRecord::Migration[5.0]
  def change
    Role.create(name: 'registered')
  end
end
