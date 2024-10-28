class AdminController < ApplicationController
  before_action :user_authorized?

  def stats
    @users = User.order('users.current_sign_in_at DESC NULLS LAST').page(params[:page]).per(50)
  end

  def create_new_user
    @user = User.new
  end

  def create_new_user_do
    @user = User.new(params.require(:user).permit(:name, :email, :password, :role))
    @user.organisation = current_user.organisation
    params[:user][:filter_ids].shift
    params[:user][:filter_ids].each do |filter_id|
      unless FiltersUser.find_by(filter_id: filter_id, user_id: @user.id)
        @user.filters_users << FiltersUser.create(filter_id: filter_id, user_id: @user.id)
      end
    end

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url, notice: "Utilisateur créé avec succès." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :create_new_user, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_authorized?
    authorize :admin
  end
end
