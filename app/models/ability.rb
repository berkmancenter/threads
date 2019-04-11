# frozen_string_literal: true
class Ability
  include CanCan::Ability

  def initialize(user, params = {})
    user ||= User.new

    if user.role? Role.admin
      can :manage, :all

      return
    end

    if user.role?(Role.anonymous) || user.role?(Role.owner) || user.role?(Role.moderator) || user.role?(Role.registered)
      can :read, Instance do |instance|
        instance.private == false || instance.access_token == params[:access_token]
      end
      can :create_room_in, Instance do |instance|
        ((instance.moderators.include?(user) || user == instance.owner || !instance.closed)) && (instance.private == false || instance.access_token == params[:access_token])
      end
      can :update, Instance do |instance|
        user == instance.owner
      end
      can :toggle_open_topic, Instance do |instance|
        user == instance.owner || instance.moderators.include?(user)
      end
      can :set_moderators, Instance do |instance|
        user == instance.owner
      end
      can :read, Room do |room|
        room.instance.private == false || room.instance.access_token == params[:access_token]
      end
      can :update, Room do |room|
        user == room.instance.owner || room.instance.moderators.include?(user)
      end
      can :destroy, Room do |room|
        [room.instance.owner, room.owner].include?(user)
      end
    end

    if user.role?(Role.owner) || user.role?(Role.registered)
      can :create, Instance
      can :destroy, Instance do |instance|
        user == instance.owner
      end
    end
  end
end
