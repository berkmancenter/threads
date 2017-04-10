# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
minh = User.create(username: 'Minh Phan', email: 'minh@xample.com', password: 'password')

10.times.each do |i|
  r = Room.create(owner_id: minh.id, title: "Room #{i + 1}")
  RoomUser.create(room_id: r.id, user_id: minh.id)
  10.times.each { |m| Message.create(content: "message content #{m}", room_id: r.id, user_id: minh.id) }
end
