class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[connect_guest_user]

  def show
    @user = current_user
    @total_tables, @total_lignes = 0, 0

    @user.tables.each do |table|
      if table.propriétaire?(@user)
        @total_tables += 1
        @total_lignes += table.size
      end
    end

    @shared_with = TablesUser.where(table_id: current_user.tables.pluck(:id)).where.not(role: 'Propriétaire')
    @tables_users = TablesUser.where(user_id: current_user.id).where.not(role: 'Propriétaire')
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.notification_nouveau_compte(@user).deliver_now
      session[:user_id] = @user.id
      redirect_to tables_path, notice:"Bienvenue '#{@user.name}' ! Votre compte a bien été créé et vous avez été notifié par mail."
    else
      render :new	
    end
  end

  def update
    @user = User.new(user_params)
    if @user.update(user_params)
      redirect_to @user, notice:'Mot de passe modifié avec succès.'
    else
      render :show
    end
  end

  def connect_guest_user
    sign_in User.find(1)
    redirect_to table_path(current_user.favorite_table), notice: "Bienvenue dans la démonstration. Vous pouvez tester ici librement l'application mais avec quelques limitations. Veuillez créer un compte pour avoir toutes les fonctionnalités."
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :remember_me)
    end

end