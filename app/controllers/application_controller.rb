class ApplicationController < ActionController::Base
  layout 'standard'
  protect_from_forgery 
  include AuthenticatedSystem

  before_filter :init_menu
  before_filter :set_logged_in
  before_filter :check_master_login
  before_filter :get_current_rights

 def entry_field ini, caption, field, parents, action_new, action_edit, auto_complete_function = 'auto_complete_on_select'
    render :partial => '/shared/entry_field', :locals => {
      :initial => ini,
      :caption => caption,
      :field => field,
      :parents => parents,
      :action_new => action_new,
      :action_edit => action_edit,
      :auto_complete_function => auto_complete_function
    }
  end

 def picture_thumb
    pic = Picture.find_by_id(params[:picture_id])
    data = params[:flag] ? pic.data : pic.icon_data
    send_data(data, :filename => 'image_' + pic.id.to_s,:type => "image/jpeg", :disposition => "inline")
  end

  protected
  def set_logged_in
    @user_logged_in = logged_in?
    User.current_user = @current_user
  end
  
  def check_master_login
    unless session[:master_login] || controller_name == 'master_login'
      redirect_to :controller => '/master_login', :action => 'index'
      return false
    end
  end
  
  def init_menu
    @menu = []
  end

  def save_address_by_date actor
    actor.address_by_dates.each do |ad|
      if params[('delete_address_by_date_' + ad.id.to_s).to_sym].blank?
        ad.update_attributes params['address_by_date_' + ad.id.to_s]
      else
        ad.destroy
      end
    end
    pnew = params['address_by_date_0']
    
    all_blank = true
    [:name, :address_line_1, :address_line_2, :address_line_3, :address_line_4,
      :zip_code, :city, :state, :country, :date_effective].each do |f|
      unless pnew[f].blank?
        all_blank = false
      end
    end
    unless all_blank
      pnew[:company_id] = actor.id
      @address_by_date = AddressByDate.create! pnew
    end
  end
  
  private
  def get_current_rights
    if logged_in? && (current_user.has_role?('admin') || current_user.has_role?('datamanager'))
      @valid_role = true
    end
  end
end
