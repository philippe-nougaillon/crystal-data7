class AdminPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def stats?
    user && ['pierre-emmanuel.dacquet@aikku.eu', 'philippe.nougaillon@aikku.eu'].include?(user.email)
  end

  def assistant_logs?
    stats?
  end

  def create_new_user?
    user && user.admin? && (!(user.compte_démo?) || Rails.env.development?)
  end

  def create_new_user_do?
    create_new_user?
  end
end
