class FilterPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    user && user.admin?
  end

  def new?
    index?
  end

  def create?
    new?
  end
  
  def edit?
    index? && record.table.organisation.users.pluck(:id).include?(user.id) && (!(user.compte_démo?) || Rails.env.development?)
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def query?
    edit?
  end
end