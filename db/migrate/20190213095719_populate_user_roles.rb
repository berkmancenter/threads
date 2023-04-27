# frozen_string_literal: true
class PopulateUserRoles < ActiveRecord::Migration[5.0]
  def change
    Role.create([
                  { name: 'admin' },
                  { name: 'owner' },
                  { name: 'moderator' },
                  { name: 'anonymous' }
                ])
  end
end
