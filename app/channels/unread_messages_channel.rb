# frozen_string_literal: true
class UnreadMessagesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "unread_messages_#{params[:room_id]}"
  end
end
