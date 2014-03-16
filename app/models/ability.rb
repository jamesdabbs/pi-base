class Ability
  include CanCan::Ability

  def initialize user
    read_only = true

    can :read, :all

    if user && user.admin?
      can :manage, :all
    elsif user
      can :create, :all unless read_only
      can :edit, :all
    end
  end
end
