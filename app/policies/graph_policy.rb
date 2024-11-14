class GraphPolicy < ApplicationPolicy
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

  def new?
    index? && (!(user.compte_démo?) || Rails.env.development?)
  end

  def create?
    new?
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
end