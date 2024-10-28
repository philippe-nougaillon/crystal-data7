class NotificationPolicy < ApplicationPolicy
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
    new? && (!(user.compte_démo?) || Rails.env.development?)
  end
  
  def edit?
    index? && record.organisation.users.pluck(:id).include?(user.id)
  end

  def update?
    edit? && (!(user.compte_démo?) || Rails.env.development?)
  end

  def destroy?
    index? && record.organisation.users.pluck(:id).include?(user.id) && (!(user.compte_démo?) || Rails.env.development?)
  end
end