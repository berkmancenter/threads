# frozen_string_literal: true
class AddAccessTokenToInstance < ActiveRecord::Migration[5.0]
  def change
    add_column :instances, :access_token, :string
  end
end
