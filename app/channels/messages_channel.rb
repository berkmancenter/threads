# frozen_string_literal: true
class MessagesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "messages_#{params[:room_id]}"
  end
end
