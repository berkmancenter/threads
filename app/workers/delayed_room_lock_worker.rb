class DelayedRoomLockWorker
  include Sidekiq::Worker

  def perform(room_id)
    room = Room.find(room_id)
    room.update_attributes!(
      locked: true,
      planned_lock: nil
    )
  end
end
