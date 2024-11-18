class AdminController < ApplicationController
  before_action :user_authorized?

  def stats
    @users = User.order('users.current_sign_in_at DESC NULLS LAST').page(params[:page]).per(50)
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

  def new_team
    @team = Team.new
  end

  def create_team
    @team = Team.new(params.require(:team).permit(:name, :filter_ids))
    @team.organisation = current_user.organisation

    respond_to do |format|
      if @team.save
        
        params[:team][:filter_ids].shift
        params[:team][:filter_ids].each do |filter_id|
          unless FiltersTeam.find_by(filter_id: filter_id, team_id: @team.id)
            @team.filters_teams << FiltersTeam.create(filter_id: filter_id, team_id: @team.id)
          end
        end
        FiltersTeam.where(team_id: @team.id).where.not(filter_id: params[:team][:filter_ids]).destroy_all

        format.html { redirect_to users_url, notice: t('teams.created') }
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
