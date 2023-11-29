class TablePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    user
  end

  def show?
    record.users.include?(user)
  end

  def new?
    index? && (!(user.compte_démo?) || Rails.env.development?)
  end

  def create?
    new?
  end

  def edit?
    record.propriétaire?(user) && (!(user.compte_démo?) || Rails.env.development?)
  end

  def update?
    edit?
  end

  def destroy?
    record.propriétaire?(user) && (!(user.compte_démo?) || Rails.env.development?)
  end
  
  def show_attrs?
    record.propriétaire?(user)
  end

  def fill?
    record.users.include?(user) && record.role_number(user) >= 1
  end

  def fill_do?
    fill?
  end

  def delete_record?
    record.propriétaire?(user) && (!(user.compte_démo?) || Rails.env.development?)
  end

  def import?
    user && (!(user.compte_démo?) || Rails.env.development?)
  end

  def import_do?
    import?
  end

  def add_user?
    record.propriétaire?(user)
  end

  def add_user_do?
    add_user? && (!(user.compte_démo?) || Rails.env.development?)
  end

  def partages?
    record.propriétaire?(user)
  end

  def partages_delete?
    partages?
  end

  def logs?
    record.propriétaire?(user)
  end

  def show_details?
    record.users.include?(user)
  end

  def related_tables?
    show_details?
  end

end