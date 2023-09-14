class ValuePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def signature?
    record.field.table.propriétaire?(user)
  end

end