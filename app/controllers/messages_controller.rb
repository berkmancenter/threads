# frozen_string_literal: true
class MessagesController < ApplicationController
  def create
    message = current_user.messages.build(message_params)
    if message.save
      num = RoomUser.update_unread_messages_count(params[:room_id], current_user.id)
      ActionCable.server.broadcast("messages_#{params[:room_id]}", message: message.content, user: current_user.username)
      ActionCable.server.broadcast("unread_messages_#{params[:room_id]}", count_unread_messages: num)
      head :ok
    else
      redirect_to room_path(params[:room_id])
    end
  end

  def destroy
  end

  private

  def message_params
    params.require(:message).permit(:content, :room_id)
  end
end
