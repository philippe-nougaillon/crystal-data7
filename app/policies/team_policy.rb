class TeamPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    user && user.admin? && (!(user.compte_démo?) || Rails.env.development?)
  end

  def create?
    new?
  end

  def edit?
    new? && record.organisation == user.organisation
  end

  def update?
    edit?
  end

  def destroy?
    new? && record.organisation == user.organisation
  end
end
