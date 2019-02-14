class Ability
  include CanCan::Ability

  def initialize(user, params = {})
    user ||= User.new

    if user.role? Role.admin
      can :manage, :all
    end

    if user.role? Role.moderator
      can :read, Instance
      can :update, Instance
      can :create_room_in, Instance
      can :read, Room
    end

    if user.role?(Role.anonymous) || user.role?(Role.owner)
      can :read, Instance do |instance|
        instance.private == false || instance.access_token == params[:access_token]
      end
      can :create_room_in, Instance do |instance|
        (user == instance.owner || !instance.closed) && (instance.private == false || instance.access_token == params[:access_token])
      end
      can :update, Instance do |instance|
        user == instance.owner
      end
      can :read, Room do |room|
        room.instance.private == false || room.instance.access_token == params[:access_token]
      end
    end
  end
end
