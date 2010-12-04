# Controller fuer die Administration von Users und Persons
class Admin::PersonController < Admin::AbstractAdminController

  before_filter :check_is_admin

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def index
    list
    render :action => 'list'
  end
  
  def list
    #@actor_pages, @actors = paginate :actors, :per_page => 30, :conditions => ['actor_type=?', "P"]
    @actors = Actor.find(:all)
  end

  def new
    @actor = Actor.new
    @user = User.new
    @person = Person.new
    @roles = Role.find(:all)
    @address_by_date_0 = AddressByDate.new
  end

  def create
    @actor = Actor.create! :actor_type => 'P'
    pp = params[:person]
    pp[:actor_id] = @actor.id
    @person = Person.new(pp)

    if params[:user][:login].blank?
      @user = nil
    else
      pu = params[:user]
      pu[:actor_id] = @actor.id
      pu[:email] = params[:person][:email]
      
      @user = User.new pu
      @user.actor_id = @actor.id
    end
    
    ps = @person.save
    us = !@user ? false : @user.save

    if ps && us && update_roles(@user)
        save_address_by_date @person.actor
        flash[:notice] = 'Пользователь добавлен успешно<br>'
        redirect_to :action => 'list'
    else
      err = ''
      @person.errors.each do |e|
        err += e.to_s + '<br>'
      end
      unless @user.nil?
        @user.errors.each do |e|
          err += e.to_s + '<br>'
        end
      end
      @actor.destroy
    #  @actor = Actor.new
      @person.destroy
     # @person = Person.new @person.attributes
    #  @roles = Role.find(:all)
      @actor = Actor.new
      @roles = Role.find(:all)
      @person = Person.new
      
      @user = User.new
      @address_by_date_0 = AddressByDate.new
      
      if err.blank?
        flash[:notice] = 'Вы не ввели необходимые данные:<br>'
      else
        flash[:notice] = 'Введённые данные содержат следующие ошибки:<br>' + err
      end  
      render :action => 'new'
    end
  end

  def edit
    aid = params[:id]
    @actor = Actor.find(aid)
    @user = User.find_by_actor_id(aid)
    @person = Person.find_by_actor_id(aid)
    @roles = Role.find(:all)

  end

  def update
    @actor = Actor.find(params[:id])
    @user = User.find(params[:user_id])
    @person = Person.find(params[:person_id])
    
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete :password
      params[:user].delete :password_confirmation
    end
    if @person.update_attributes(params[:person]) && @user.update_attributes(params[:user]) && update_roles(@user)
      #save_address_by_date @person.actor
      flash[:notice] = 'Данные успешно добавлены'
     
     if params[:path].nil?
    	  redirect_to :action => 'list'
     else
    	redirect_to :controller => "/profile", :action => params[:path]
     end
     
    else
      render :action => 'edit'
    end
  end

  def destroy
    User.find_by_actor_id(params[:id]).destroy
    #!!!!!!!!!!Pictures
    Person.find_by_actor_id(params[:id]).destroy
#    AddressByDate.find_all_by_actor_id(params[:id]).each {|q|
#      q.destroy
#    }
    
 
    if params[:path].nil?
      Actor.find(params[:id]).destroy
      redirect_to :action => 'list'
    else
      CustomCompanyName.find_by_actor_id(params[:id]).destroy
      Actor.find(params[:id]).destroy
      redirect_to :controller => "/profile", :action => params[:path]
    end
  end
  
  protected
  def init_menu
    @menu = [:admin, :person]
  end
  
  private
  def update_roles user
    Role.find(:all).each do |r|
      p = params[('role_' + r.id.to_s).to_sym]
      if user.has_role?(r.name) && p.blank?
        user.has_no_role r.name
      elsif !user.has_role?(r.name) && !p.blank?
        user.has_role r.name
      end
    end
  end

  private
  def check_is_admin
    unless logged_in? && current_user.has_role?('datamanager')
      flash[:error] = 'Для выполнения данной операции вы должны иметь права администратора'
      redirect_to :controller => '/home', :action => 'index'
      return false
    end
  end

end
