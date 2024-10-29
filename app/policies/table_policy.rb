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
    record.instance_of?(Table) && (user.admin? || (user.team.filters.pluck(:table_id)).include?(record.id))
  end

  def new?
    index? && user.admin? && (!(user.compte_démo?) || Rails.env.development?)
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
    record.public? || (record.users.include?(user) && (user.admin? || (user.team.filters.pluck(:table_id)).include?(record.id)))
  end

  def fill_do?
    fill? && (!( user && user.compte_démo?) || Rails.env.development?)
  end

  def delete_record?
    record.propriétaire?(user) && (!(user.compte_démo?) || Rails.env.development?)
  end

  def import?
    user && user.admin? && (!(user.compte_démo?) || Rails.env.development?)
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
    partages? && (!(user.compte_démo?) || Rails.env.development?)
  end

  def logs?
    record.propriétaire?(user)
  end

  def show_details?
    record.users.include?(user) && (user.admin? || (user.team.filters.pluck(:table_id)).include?(record.id))
  end

  def related_tables?
    show_details?
  end

  def icalendar?
    true
  end

  def securite?
    user && user.admin?
  end

end