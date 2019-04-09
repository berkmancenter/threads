# frozen_string_literal: true
class MessagesController < ApplicationController
  def create
    room_id = params[:room_id]
    room = Room.find(params[:room_id])

    #return head :not_acceptable if room.locked

    message = current_or_guest_user.messages.build(message_params.merge(room_id: room_id))
    if message.save
      RoomUser.update_last_read_message!(room_id, current_or_guest_user.id, message.id)
      ActionCable.server.broadcast("room_#{room_id}", content: message.content, username: current_or_guest_user.nickname_in_room(room))
      ActionCable.server.broadcast(
        'unread_message',
        room_id: room_id
      )
      head :ok
    else
      render json: message.errors.messages, status: :unprocessable_enity
    end
  end

  def destroy; end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
