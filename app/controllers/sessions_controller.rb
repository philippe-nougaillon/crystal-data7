class SessionsController < ApplicationController
  before_action :authorize, except:[:new, :create, :demo]

  def new
    @user.email = params[:m] if params[:m]

    respond_to do |format|
      format.html.phone 
      format.html.none
    end
  end

  def create
    user = User.find_by_email(params[:user][:email])
    if user && user.authenticate(params[:user][:password])
      update_authentication_token(user, params[:user][:remember_me])
      session[:user_id] = user.id
      flash[:notice] = "Bienvenue '#{user.name}' !"
      redirect_to tables_path
    else
      redirect_to '/login', alert:"Utilisateur ou mot de passe inconnu !"
    end
  end

  def demo
      user = User.find(1)
      session[:user_id] = user.id
      update_authentication_token(user, true)
      flash[:notice] = "Bienvenue dans le mode 'démonstration' !"
      redirect_to tables_path
  end

  def destroy
    user = User.find(session[:user_id])
    update_authentication_token(user, nil)
    session[:user_id] = nil
    redirect_to root_path
  end

  def update_authentication_token(user, remember_me)
    if remember_me == "1"
      # create an authentication token if the user has clicked on remember me
      auth_token = SecureRandom.urlsafe_base64
      user.authentication_token = auth_token
      cookies.permanent[:auth_token] = auth_token
    else # nil or 0
      # if not, clear the token, as the user doesn't want to be remembered.
      user.authentication_token = nil
      cookies.permanent[:auth_token] = nil
    end
    #logger.debug "DEBUG update_authentication_token user_valid? #{user.valid?} user:#{user.inspect} error:#{user.errors.full_messages}" 
    user.save(validate:false)
  end

end