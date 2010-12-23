# encoding: UTF-8
class UsersController < ApplicationController
  before_filter :create_brain_buster, :only => :new
  before_filter :validate_brain_buster, :only => :create
  def new 
  end
     
  def create
    user = params[:user]
    return if check_user_data(user, params)

    unless params[:company_id].empty?
      user = User.create!(user)
      params[:datamanager_role] ? user.has_role('datamanager') : user.has_role('user')
      CustomCompanyName.create!(:actor_id => actor_id,
                                :company_id => params[:company_id])
    else
      reset_session
      session[:master_login] = true
      user = User.create!(user)
      user.has_role 'user'
      user.has_role 'datamanager'
      self.current_user = user
    end
    flash[:notice] = 'Спасибо за регистрацию!'
    redirect_to :controller => '/profile', :action => 'show'
    
  end

  private
  
  def render_or_redirect_for_captcha_failure
    render :action => "new"
  end

  def check_user_data(user, params)
    err = ''
    if user[:login].blank?
      err << "Пожалуйста заполните поле 'Login'." + '<br>'
    else
      if User.find_by_login(user[:login])
        err << 'Пользователь с логином \'' + user[:login] + '\' ' + ' уже существует!' + '<br/>'
      end
    end

    if user[:email].blank? or user[:email].index("@").nil?
      err << 'Укажите правельный email адресс' + '<br>'
    end

    if user[:password].blank? or user[:password].length < 4
      err << 'Пароль не может быть пустым или менее 4 символов' + '<br/>'
    else
      unless user[:password] == user[:password_confirmation]
        err << 'Подтверждающий пароль не совпадает' + '<br/>'
      end
    end

#    unless simple_captcha_valid?
#      err << 'Вы не верно ввыли текст, представленный на картинке.' + '<br/>'
#    end

    unless err.blank?
     flash[:error] = err
      @user = User.new(user)

      unless params[:company_id].empty?
        redirect_to :controller => "/signup" , :company_id => params[:company_id]
      else
        redirect_to :controller => "/signup"
      end
      true
    end
  end
end
