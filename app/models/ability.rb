class Ability
  include CanCan::Ability

  def initialize user
    read_only = true

    can :read, :all

    if user && user.admin?
      can :manage, :all
    elsif user && !read_only
      can :create, :all
      can :edit, :all
    end
  end
end
