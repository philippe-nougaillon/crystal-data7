class PagesPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def a_propos?
    true
  end

  def graphs?
    user && user.admin?
  end

  def mentions_legales?
    true
  end

  def assistant?
    user && user.admin?
  end
end
