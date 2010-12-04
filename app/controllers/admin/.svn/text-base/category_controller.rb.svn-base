class Admin::CategoryController < Admin::AbstractAdminController#ApplicationController

  def index
    @selected_company_id = params[:company_id]
    @selected_company = @selected_company_id ? Company.find_by_id(@selected_company_id) : nil
    @cities = City.find(:all, :order => ' name')
  end
  
  def cities
    city = City.find_by_id(params[:city_id])
    companies = city.company
    render :update do |page|
      page.replace_html 'city_' + params[:city_id].to_s, :partial => 'companies', :locals => {:companies => companies, :city => city}
    end
  end
  
  def categories_for_country
    root = Company.find_by_id(params[:company_id])
    render :update do |page|
      page.replace_html 'categories', :partial => 'categories_outer', :locals => {:root => root, :depth => 0}
    end
  end
  
  def get_category_id(root)
    root.kind_of?(Company) ? nil : root.id
  end
  
  def get_country_id(root)
    root.kind_of?(Company) ? root.id : root.company_id
  end
  
  def add_category
    @category = Category.new(:parent_category_id => params[:parent_category_id],
                             :company_id => params[:country_id])
    render :action => 'edit'
  end
  
  def edit
    @category = Category.find_by_id(params[:category_id])
    @company = Company.find(:all)
  end

  protected
  def init_menu
    @menu = [:admin, :category]
  end
end
