class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :is_user_authorized?, except: %i[connect_guest_user]
  skip_before_action :authenticate_user!, only: %i[connect_guest_user]

  def index
    @users = current_user.organisation.users
  end

  # GET /users/1 or /users/1.json
  # def show
  # end

  def profil
    @user = current_user
    @total_tables, @total_lignes = 0, 0

    @user.tables.each do |table|
      if table.propriétaire?(@user)
        @total_tables += 1
        @total_lignes += table.size
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        params[:user][:filter_ids].shift
        params[:user][:filter_ids].each do |filter_id|
          unless FiltersUser.find_by(filter_id: filter_id, user_id: @user.id)
            @user.filters_users << FiltersUser.create(filter_id: filter_id, user_id: @user.id)
          end
        end
        FiltersUser.where(user_id: @user.id).where.not(filter_id: params[:user][:filter_ids]).destroy_all

        format.html { redirect_to users_url, notice: "Utilisateur modifié avec succès." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to root_path, notice: t('notice.organisation.destroyed') }
      format.json { head :no_content }
    end
  end

  def connect_guest_user
    sign_in User.find(1)
    # if (current_user.last_sign_in_ip != current_user.current_sign_in_ip) || (current_user.current_sign_in_at - current_user.last_sign_in_at > 60 * 5)
    #   UserMailer.new_guest_notification(request.referrer).deliver_now
    # end
    redirect_to table_path(current_user.favorite_table), notice: t('notice.table.index')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find_by(slug: params[:id])
  end
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :remember_me, :role)
  end

  def is_user_authorized?
    authorize @user? @user : User
  end

end