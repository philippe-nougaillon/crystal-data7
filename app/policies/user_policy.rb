class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user && user.admin?
  end

  def show?
    index? && record.organisation == user.organisation
  end

  def edit?
    show? && (!(user.compte_démo?) || Rails.env.development?)
  end

  def update?
    edit?
  end

  def destroy?
    show? && (!(user.compte_démo?) || Rails.env.development?)
  end

  def icalendar?
    true
  end

  def profil?
    user
  end

end
