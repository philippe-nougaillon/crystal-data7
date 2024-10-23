class AdminPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def stats?
    user && ['pierreemmanuel.dacquet@gmail.com', 'philippe.nougaillon@gmail.com'].include?(user.email)
  end

  def create_new_user?
    user && user.admin? && (!(user.compte_démo?) || Rails.env.development?)
  end

  def create_new_user_do?
    create_new_user?
  end
end
