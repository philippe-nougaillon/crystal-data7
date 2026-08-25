class TeamsController < ApplicationController
  before_action :set_team, except: [:new, :create]
  before_action :is_user_authorized?

  def new
    @team = Team.new
  end

  def edit
  end

  def create
    @team = Team.new(team_params)
    @team.organisation = current_user.organisation

    respond_to do |format|
      if @team.save
        if params.dig(:team, :filter_ids).present?
          filter_ids = Array(params[:team][:filter_ids]).compact_blank
          filter_ids.each do |filter_id|
            unless FiltersTeam.find_by(filter_id: filter_id, team_id: @team.id)
              @team.filters_teams << FiltersTeam.create(filter_id: filter_id, team_id: @team.id)
            end
          end
          FiltersTeam.where(team_id: @team.id).where.not(filter_id: filter_ids).destroy_all
        end

        format.html { redirect_to users_url, notice: t('notice.team.created') }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @team.update(team_params)
        if params.dig(:team, :filter_ids).present?
          filter_ids = Array(params[:team][:filter_ids]).compact_blank
          filter_ids.each do |filter_id|
            unless FiltersTeam.find_by(filter_id: filter_id, team_id: @team.id)
              @team.filters_teams << FiltersTeam.create(filter_id: filter_id, team_id: @team.id)
            end
          end
          FiltersTeam.where(team_id: @team.id).where.not(filter_id: filter_ids).destroy_all
        end
        format.html { redirect_to users_url, notice: t('notice.team.updated') }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: t('notice.team.destroyed')}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find_by(slug: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:name, :filter_ids)
    end

    def is_user_authorized?
      authorize @team ? @team : Team
    end
end
