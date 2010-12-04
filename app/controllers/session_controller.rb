# This controller handles the login/logout function of the site.  
class SessionController < ApplicationController
  def new
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      StatsLogin.log params[:login], 'Регистрации'
      flash[:notice] = 'Login подтверждён'
      redirect_to :controller => '/profile', :action => 'show'
    else
      flash[:error] = 'Login не корректен'
      render :action => 'new'
    end
  end

  def destroy
    reset_session
    session[:master_login] = false
    flash[:notice] = 'Выход осушествлён успешно'
    redirect_back_or_default('/')
  end
end
