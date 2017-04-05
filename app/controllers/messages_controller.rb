# frozen_string_literal: true
class MessagesController < ApplicationController
  def create
    message = current_user.messages.build(message_params)
    if message.save
      room_id = message_params[:room_id]
      RoomUser.update_last_read_message!(room_id, current_user.id, message.id)
      ActionCable.server.broadcast("room_#{room_id}", message: message.content, user: current_user.username)
      ActionCable.server.broadcast('unread_message', room_id: room_id)
      head :ok
    else
      render json: message.errors.messages, status: :unprocessable_enity
    end
  end

  def destroy
  end

  private

  def message_params
    params.require(:message).permit(:content, :room_id)
  end
end
