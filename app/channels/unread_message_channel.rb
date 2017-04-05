# frozen_string_literal: true
class UnreadMessageChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'unread_message'
  end
end
