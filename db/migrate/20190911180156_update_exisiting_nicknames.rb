class UpdateExisitingNicknames < ActiveRecord::Migration[5.2]
  def change
    RoomUserNickname.all.each do |existingNicknameInRoom|
      nickname_in_room = loop do
        nickname = [
          Faker::Space.planet,
          Faker::Space.moon,
          Faker::Space.galaxy,
          Faker::Space.star,
          Faker::TvShows::Stargate.planet,
          Faker::Movies::StarWars.planet,
          Faker::Games::Witcher.location
        ].sample

        break nickname unless RoomUserNickname.exists?(
          room: existingNicknameInRoom.room,
          nickname: nickname
        )
      end

      existingNicknameInRoom.nickname = nickname_in_room
      existingNicknameInRoom.save!
    end
  end
end
