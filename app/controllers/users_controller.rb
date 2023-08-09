# encoding: utf-8

class UsersController < ApplicationController
  	before_action :authorize, except: [:new, :create]

  	def show
  		@user = @current_user
      @total_tables, @total_lignes, @fichiers, @total_fichiers = 0, 0, 0, 0

      @user.tables.each do |table|
        if table.is_owner?(@user)
           @total_tables += 1
           @total_lignes += table.size
           @fichiers += table.files_count
           @total_fichiers += table.files_size
        end
      end
  	end

    def new
    	@user = User.new
    end

    def create
	    @user = User.new(user_params)
	    if @user.save
        UserMailer.notification_nouveau_compte(@user).deliver_later
        session[:user_id] = @user.id
        redirect_to tables_path, notice:"Bienvenue '#{@user.name}' !. Votre compte a bien été créé et vous avez été notifié par mail."
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

  private
  	def user_params
    	params.require(:user).permit(:name, :email, :password, :password_confirmation, :remember_me)
  	end

end