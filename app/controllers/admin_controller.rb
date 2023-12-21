class AdminController < ApplicationController
  before_action :user_authorized?

  def stats
    @users = User.order('users.current_sign_in_at DESC').page(params[:page]).per(50)
  end

  private
  def user_authorized?
    authorize :admin
  end
end
