class Ability
  include CanCan::Ability

  def initialize(user, params)
    user ||= User.new

    if user.role? Role.admin
      can :manage, :all
    end

    if user.role? Role.moderator
      can :read, Instance
      can :update, Instance
      can :create_room_in, Instance
    end

    if user.role? Role.anonymous
      can :read, Instance, private: false
      can :create_room_in, Instance do |instance|
        user == instance.owner || !instance.closed
      end
      can :update, Instance do |instance|
        user == instance.owner
      end
    end

    can :read, Room
  end
end
