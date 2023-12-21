class AdminController < ApplicationController
  before_action :user_authorized?

  def stats
    @users = User.all.page(params[:page]).per(20)
  end

  private
  def user_authorized?
    authorize :admin
  end
end
