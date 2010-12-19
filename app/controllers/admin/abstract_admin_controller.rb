# encoding: UTF-8
class Admin::AbstractAdminController < ApplicationController
  
  before_filter :check_is_admin_or_datamanager
  
  protected
  def init_menu
    @menu = [:admin]
  end

  private
  def check_is_admin_or_datamanager
    unless logged_in? && (current_user.has_role?('datamanager'))
      flash[:error] = 'Для выполнения данной операциии вам нужны права менеджера данных'
      redirect_to :controller => '/home', :action => 'index'
      return false
    end
  end

end