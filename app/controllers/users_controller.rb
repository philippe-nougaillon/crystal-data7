class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  skip_before_action :authenticate_user!, only: %i[connect_guest_user]
  before_action :is_user_authorized?, except: %i[connect_guest_user]

  def show
    @total_tables, @total_lignes = 0, 0

    @user.tables.each do |table|
      if table.propriétaire?(@user)
        @total_tables += 1
        @total_lignes += table.size
      end
    end
  end

  def destroy
    # unless ['pierreemmanuel.dacquet@gmail.com', 'philippe.nougaillon@gmail.com'].include?(current_user.email)
    #   AdminMailer.with(organisation: @organisation, reason: params[:reason]).suppression_organisation_notification.deliver_now
    # end

    table_ids = TablesUser.where(user_id: @user.id, role: 'Propriétaire').pluck(:table_id)

    Table.where(id: table_ids).destroy_all
    @user.destroy

    # TODO: ???
      
    if ['pierreemmanuel.dacquet@gmail.com', 'philippe.nougaillon@gmail.com'].include?(current_user.email)
      respond_to do |format|
        format.html { redirect_to admin_stats_path }
        format.json { head :no_content }
      end
    else
      # sign_out

      # respond_to do |format|
      #   format.html { redirect_to root_path, notice: "Tout a bien été supprimé. En espérant vous revoir prochainement :)" }
      #   format.json { head :no_content }
      # end
    end
  end

  def connect_guest_user
    sign_in User.find(1)
    if (current_user.last_sign_in_ip != current_user.current_sign_in_ip) || (current_user.current_sign_in_at - current_user.last_sign_in_at > 60 * 5)
      UserMailer.new_guest_notification(request.referrer).deliver_now
    end
    redirect_to table_path(current_user.favorite_table), notice: "(i)Bienvenue dans la démonstration. Vous pouvez tester ici librement l'application mais avec quelques limitations. Veuillez créer un compte pour avoir toutes les fonctionnalités."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find_by(slug: params[:id])
  end
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :remember_me)
  end

  def is_user_authorized?
    authorize @user? @user : User
  end

end