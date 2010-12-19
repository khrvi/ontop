# encoding: UTF-8
class Admin::CompanyController < Admin::AbstractAdminController
 
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def index
    list
    render :action => 'list'
  end

  def list
   sort =  params[:sort_column].nil? ? 'name' : params[:sort_column]
    @companies = Company.find(:all)
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(params[:company])
    if @company.save
      flash[:notice] = 'Успешно сохранено'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @company = Company.find(params[:id])
  end

  def update
    @company = Company.find(params[:id])
    if @company.update_attributes(params[:company])
      flash[:notice] = 'Информация о компании "' + @company.name + '" ' + 'успешно обнавлена.'.t
      redirect_to :action => 'list', :id => @company
    else
      render :action => 'edit'
    end
  end

  def destroy
    Company.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  protected
  def init_menu
    @menu = [:admin, :country]
  end

end
