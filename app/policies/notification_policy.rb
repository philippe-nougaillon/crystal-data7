class NotificationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    user
  end

  def new?
    user
  end

  def create?
    new?
  end
  
  def edit?
    user
    # record.user_id == user.id
  end

  def update?
    edit?
  end

  def destroy?
    user
    # record.user_id == user.id && (!(user.compte_démo?) || Rails.env.development?)
  end
end