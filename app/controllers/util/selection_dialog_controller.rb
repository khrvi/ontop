class Util::SelectionDialogController < ApplicationController
  
  def select_one_category
      
    r                 = params[:category_id]
    select_controller = params[:select_controller]
    select_action     = params[:select_action]
    answer_ajax       = params[:answer_ajax]

    #if r.blank?
  
      #show_dialog_category :one_category, 'Выберите категорию',name_combo, select_controller, select_action, answer_ajax
    render :update do |page|
      dialog_html = render :partial => 'dialog',
          :locals => { :title  => "Выберите категорию",  :div  => 'categories'}
      
      page.call 'set_dialog_size', '400px', '300px'
      page.call 'show_modal_dialog', dialog_html
    end
  
    #else
#    
#      category = Category.find_by_id r
#      country = category.company
#      city = country.city
#      show_dialog_category :one_category,'Выберите категорию',name_combo, select_controller, select_action, answer_ajax, city, country, category
#    end
  end
  
  
  def test
    
    select_controller = params[:select_controller]
    select_action     = params[:select_action]
    answer_ajax       = params[:answer_ajax]
    name       = params[:obj]
      render :update do |page|
      dialog_html = render :partial => 'dialog',
          :locals => { :title  => "Выберите город и район",  :div  => 'cities', :name => name}
      
      page.call 'set_dialog_size', '400px', '200px'
      page.call 'show_modal_dialog', dialog_html
    end
    
    
  end
   
  
  def update_merch

    
     category_id = params[:category_id]
    if category_id.blank?
      category_id = nil
      category = nil
    else
      category_id = category_id.to_i
      category = Category.find_by_id(category_id)
    end
   
    #remote_function(:url => { :controller => '/admin/merchandise',:action => 'update_category'} , :category_id => category_id )
    render :update do |page|
        page.replace_html 'categ', :partial => '/admin/merchandise/category_details', :locals => {:category_id => category_id,:category => category,  :answer_ajax => true}
        page.replace_html 'pa', :partial => '/search/parameters_field', :locals => {:category_id => category_id,  :create_new_mer => true}
        page.call 'hide_modal_dialog'
    end
    
  end
  
  def select_merchandise
    w                 = params[:merchan_id]
    select_controller = params[:select_controller]
    select_action     = params[:select_action]
    answer_ajax       = params[:answer_ajax]
    if w.blank?
      show_dialog :merchandise, 'Weingut wählen', nil, select_controller, select_action, answer_ajax
    else
      merchandise = Merchandise.find_by_id w
      category = merchandise.category
      country = category.company
      city = country.city
      show_dialog :merchandise, 'Weingut wählen', nil, select_controller, select_action, answer_ajax, city, country, category, merchandise
    end
  end
  
  def select_brand
    b                 = params[:brand_id]
    select_controller = params[:select_controller]
    select_action     = params[:select_action]
    answer_ajax       = params[:answer_ajax]
    if b.blank?
      show_dialog :brand, 'Brand wählen', nil, select_controller, select_action, answer_ajax
    else
      brand = Brand.find_by_id b
      merchandise = brand.merchandise
      category = merchandise.category
      country = category.company
      city = country.city
      show_dialog :merchandise, 'Weingut wählen', nil, select_controller, select_action, answer_ajax, city, country, category, merchandise, brand
    end
  end

  def categories_for_country
    select_controller = params[:select_controller]
    select_action     = params[:select_action]
    answer_ajax       = params[:answer_ajax]
    mode              = params[:mode].to_sym
   
    root = Company.find_by_id(params[:country_id])
#    selected_category = params[:selected_category_id]
    render :update do |page|
      page.replace_html 'categories', :partial => 'categories_container',
          :locals => {:root => root,
                      :depth => 0,
                      :selected_category   => nil,
                      :select_controller => select_controller,
                      :select_action     => select_action,
                      :answer_ajax       => answer_ajax,
                      :mode              => mode,
                      :name_combo => params[:name_combo]
          }
    end
  end

  def merchandises_for_category
    select_controller = params[:select_controller]
    select_action     = params[:select_action]
    answer_ajax       = params[:answer_ajax]
    mode              = params[:mode].to_sym
    category = Category.find_by_id(params[:category_id])
#    selected_category = params[:selected_category_id]
    render :update do |page|
      page.replace_html 'merchandises', :partial => 'merchandises',
          :locals => {:category => category,
                      :select_controller => select_controller,
                      :select_action     => select_action,
                      :answer_ajax       => answer_ajax,
                      :mode              => mode
          }
    end
  end

  def brands_for_merchandise
    select_controller = params[:select_controller]
    select_action     = params[:select_action]
    answer_ajax       = params[:answer_ajax]
    mode              = params[:mode].to_sym
    merchandise = Merchandise.find_by_id(params[:merchan_id])
    render :update do |page|
      page.replace_html 'brands', :partial => 'brands',
          :locals => {:merchandise => merchandise,
                      :select_controller => select_controller,
                      :select_action     => select_action,
                      :answer_ajax       => answer_ajax,
                      :mode              => mode
          }
    end
  end

  private
  def show_dialog  mode, title, name_combo,select_controller, select_action, answer_ajax, def_city = nil, def_country = nil, def_category = nil,  def_merchandise = nil, def_brand = nil
        
    all_cities = City.find(:all, :order => 'name')
    render :update do |page|
      dialog_html = render :partial => 'dialog',
          :locals => {:all_cities     => all_cities,
                      :selected_city => def_city,
                      :selected_country   => def_country,
                      :selected_category    => def_category,
                      :selected_merchandise    => def_merchandise,
                      :selected_brand     => def_brand,
                      :select_controller  => select_controller,
                      :select_action      => select_action,
                      :answer_ajax        => answer_ajax,
                      :mode               => mode,
                      :title              => title,
                      :name_combo => name_combo}
      page.call 'set_dialog_size', '600px', '400px'
      page.call 'show_modal_dialog', dialog_html
    end
  end
 
  #show_dialog_category :one_category, 'Category wählen',name_combo, select_controller, select_action, answer_ajax
  def  show_dialog_category  mode, title, name_combo,select_controller, select_action, answer_ajax, def_city = nil, def_country = nil, def_category = nil,  def_merchandise = nil, def_brand = nil
        
   # all_cities = City.find(:all, :order => 'name')
    all_cities = Category.find(:all, :order => 'name')
   
    render :update do |page|
      dialog_html = render :partial => 'dialog',
          :locals => {:all_cities     => all_cities,
                      :selected_city => def_city,
                      :selected_country   => def_country,
                      :selected_category    => def_category,
                      :selected_merchandise    => def_merchandise,
                      :selected_brand     => def_brand,
                      :select_controller  => select_controller,
                      :select_action      => select_action,
                      :answer_ajax        => answer_ajax,
                      :mode               => mode,
                      :title              => title,
                      :name_combo => name_combo}
      page.call 'set_dialog_size', '600px', '400px'
      page.call 'show_modal_dialog', dialog_html
    end
  end
  
  
end
