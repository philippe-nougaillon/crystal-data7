class MessagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    user
  end

  def new?
    user && (!(user.compte_démo?) || Rails.env.development?)
  end

  def create?
    new?
  end
  
  def edit?
    record.user_id == user.id
  end

  def update?
    edit?
  end

  def destroy?
    record.user_id == user.id && (!(user.compte_démo?) || Rails.env.development?)
  end
end