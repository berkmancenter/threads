class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.role? Role.admin
      can :manage, :all
    end

    if user.role? Role.anonymous
      can :read, Instance, private: false
      can :create, Room
    end

    can :read, Room
  end
end
