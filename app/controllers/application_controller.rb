# frozen_string_literal: true
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_or_guest_user

  rescue_from CanCan::AccessDenied do |_exception|
    redirect_to main_app.root_path, alert: 'Permission denied!'
  end

  # if user is logged in, return current_user, else return guest_user
  def current_or_guest_user
    if current_user
      if session[:guest_user_id] && session[:guest_user_id] != current_user.id
        logging_in
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  # find guest_user object associated with the current session,
  # creating one as needed
  def guest_user(with_retry = true)
    # Cache the value the first time it's gotten.
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)

  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
     session[:guest_user_id] = nil
     guest_user if with_retry
  end

  private

  # called (once) when the user logs in, insert any code your application needs
  # to hand off from guest_user to current_user.
  def logging_in
    # For example:
    # guest_comments = guest_user.comments.all
    # guest_comments.each do |comment|
      # comment.user_id = current_user.id
      # comment.save!
    # end
  end

  def create_guest_user
    u = User.new(
      username: "guest_#{Time.now.to_i}#{rand(100)}",
      email: "guest_#{Time.now.to_i}#{rand(100)}@example.com",
      roles: [Role.find_by(name: 'anonymous')]
    )
    u.save!(validate: false)
    session[:guest_user_id] = u.id
    u
  end

  def current_ability
    @current_ability ||= Ability.new(current_or_guest_user, params)
  end
end
