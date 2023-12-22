class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    user && record == user
  end

  def destroy?
    user && (record == user || ['pierreemmanuel.dacquet@gmail.com', 'philippe.nougaillon@gmail.com'].include?(user.email))
  end

  def icalendar?
    true
  end

end
