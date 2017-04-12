# frozen_string_literal: true
class MessagesController < ApplicationController
  def create
    room_id = params[:room_id]
    message = current_user.messages.build(message_params.merge(room_id: room_id))
    if message.save
      RoomUser.update_last_read_message!(room_id, current_user.id, message.id)
      ActionCable.server.broadcast("room_#{room_id}", content: message.content, username: current_user.username)
      ActionCable.server.broadcast('unread_message', room_id: room_id)
      head :ok
    else
      render json: message.errors.messages, status: :unprocessable_enity
    end
  end

  def destroy
  end

  def old
    room = Room.find(params[:room_id])
    messages = room.messages.where('id < ?', params[:first_message_id]).limit(40).order(id: :desc)
    render json: messages, each_serializer: MessageSerializer, status: :ok
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
