class OrganisationPolicy < ApplicationPolicy
  def show?
    user && user.admin? && record == user.organisation
  end

  def edit?
    show? && (!(user.compte_démo?) || Rails.env.development?)
  end

  def update?
    edit?
  end

  def destroy?
    false
  end
end
