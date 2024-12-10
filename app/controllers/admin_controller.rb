class AdminController < ApplicationController
  before_action :user_authorized?

  def stats
    @organisations = Organisation.all.page(params[:page]).per(3)
    # @users = User.order('users.current_sign_in_at DESC NULLS LAST').page(params[:page]).per(50)
  end

  def assistant_logs
    if params[:id].present?
      @prompts = Prompt.where(id: params[:id])
    else
      @prompts = Prompt.ordered
    end
  end

  def create_new_user
    @user = User.new
  end

  def create_new_user_do
    @user = User.new(params.require(:user).permit(:name, :email, :password, :role, :team_id))
    @user.organisation = current_user.organisation

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url, notice: t('users.created') }
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
