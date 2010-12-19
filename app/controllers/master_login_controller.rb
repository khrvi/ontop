# encoding: UTF-8
class MasterLoginController < ApplicationController

  layout 'plain'
  
  def index
  end
  
  def login
    ml = MasterLogin.find_by_login(params[:master_login])
    if ml && ml.password == params[:master_password]
      session[:master_login] = true
      #session[:city] = City.find_by_name('Минск').id.to_s
      redirect_to :controller => '/home', :action => 'index'
    else
      flash[:error] = 'Неверный имя/пароль'
      redirect_to :action => 'index'
    end
  end
end
