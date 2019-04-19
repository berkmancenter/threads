# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    protected

    def find_verified_user
      logger.error session.inspect
      User.find_by(id: session['guest_user_id'] || session['warden.user.user.key'][0]) || reject_unauthorized_connection
    end

    def session
      cookies.encrypted[Rails.application.config.session_options[:key]]
    end
  end
end
