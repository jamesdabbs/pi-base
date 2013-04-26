class Ability
  include CanCan::Ability

  def initialize user
    can :read, :all

    if user && user.admin?
      can :manage, :all
    elsif user
      can :create, :all
      can :edit, :all
    end
  end
end
