class FieldPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    record.table.propriétaire?(user)
  end
  
  def edit?
    record.table.propriétaire?(user)
  end

  def update?
    edit?
  end

  def destroy?
    record.table.propriétaire?(user)
  end

  def update_row_order?
    record.table.propriétaire?(user)
  end
end