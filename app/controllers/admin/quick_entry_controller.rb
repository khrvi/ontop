class Admin::QuickEntryController < Admin::AbstractAdminController

  def index
#    @initial = {}
#
#    [:continent_t, :country_t, :region_t, :winery_t, :brand_t, :wine_t].each do |obj|
#      obj_hash = {}
#      [:id, :name, :name_for_id].each do |fld|
#        param_name = obj.to_s + '_' + fld.to_s
#        unless params[param_name].blank?
#          obj_hash[fld] = params[param_name]
#        end
#      end
#      @initial[obj] = obj_hash
#    end
  end
  

#  def new_wine_country
#    render :update do |page|
#      page.redirect_to :controller => 'admin/company',
#        :action => 'new',
#        :continent_id => SelectByTextController.get_param_id(params[:continent_t]),
#        :return_controller => 'admin/quick_entry',
#        :return_action => 'wine_country_created'
#    end
#  end
#
#  def new_region
#    render :update do |page|
#      page.redirect_to :controller => 'admin/region',
#        :action => 'add_region',
#        :country_id => SelectByTextController.get_param_id(params[:country_t]),
#        :parent_region_id => SelectByTextController.get_param_id(params[:region_t]),
#        :return_controller => 'admin/quick_entry',
#        :return_action => 'region_created'
#    end
#  end
#
#  def new_winery
#    render :update do |page|
#      page.redirect_to :controller => 'admin/winery',
#        :action => 'new',
#        :continent_id => SelectByTextController.get_param_id(params[:continent_t]),
#        :wine_country_id => SelectByTextController.get_param_id(params[:country_t]),
#        :region_id => SelectByTextController.get_param_id(params[:region_t]),
#        :return_controller => 'admin/quick_entry',
#        :return_action => 'winery_created'
#    end
#  end
#
#  def new_brand
#    render :update do |page|
#      page.redirect_to :controller => 'admin/brand',
#        :action => 'new',
#        :continent_id => SelectByTextController.get_param_id(params[:continent_t]),
#        :wine_country_id => SelectByTextController.get_param_id(params[:country_t]),
#        :region_id => SelectByTextController.get_param_id(params[:region_t]),
#        :winery_id => SelectByTextController.get_param_id(params[:winery_t]),
#        :return_controller => 'admin/quick_entry',
#        :return_action => 'brand_created'
#    end
#  end
#
#  def new_wine
#    render :update do |page|
#      page.redirect_to :controller => 'admin/wine',
#        :action => 'new',
#        :continent_id => SelectByTextController.get_param_id(params[:continent_t]),
#        :wine_country_id => SelectByTextController.get_param_id(params[:country_t]),
#        :region_id => SelectByTextController.get_param_id(params[:region_t]),
#        :winery_id => SelectByTextController.get_param_id(params[:winery_t]),
#        :brand_id => SelectByTextController.get_param_id(params[:brand_t]),
#        :return_controller => 'admin/quick_entry',
#        :return_action => 'wine_created'
#    end
#  end
#
#  def edit_wine_country
#    id = SelectByTextController.get_param_id(params[:country_t])
#    if id.nil?
#      c = WineCountry.find_by_name(params[:country_t][:name])
#      if c
#        id = c.id
#      end
#    end
#    if id
#      render :update do |page|
#        page.redirect_to :controller => 'admin/country',
#          :action => 'edit',
#          :id => id,
#          :return_controller => 'admin/quick_entry',
#          :return_action => 'wine_country_created'
#      end
#    else
#      render :nothing => true
#      return false
#    end
#  end
#
#  def edit_region
#    id = SelectByTextController.get_param_id(params[:region_t])
#    if id.nil?
#      c = Region.find_by_name(params[:region_t][:name])
#      if c
#        id = c.id
#      end
#    end
#    if id
#      render :update do |page|
#        page.redirect_to :controller => 'admin/region',
#          :action => 'edit',
#          :region_id => id,
#          :return_controller => 'admin/quick_entry',
#          :return_action => 'region_created'
#      end
#    else
#      render :nothing => true
#      return false
#    end
#  end
#
#  def edit_winery
#    id = SelectByTextController.get_param_id(params[:winery_t])
#    if id
#      render :update do |page|
#        page.redirect_to :controller => 'admin/winery',
#          :action => 'edit',
#          :id => id,
#          :return_controller => 'admin/quick_entry',
#          :return_action => 'winery_created'
#      end
#    else
#      render :nothing => true
#      return false
#    end
#  end
#
#  def edit_brand
#    id = SelectByTextController.get_param_id(params[:brand_t])
#    if id.nil?
#      c = Brand.find_by_name(params[:brand_t][:name])
#      if c
#        id = c.id
#      end
#    end
#    if id
#      render :update do |page|
#        page.redirect_to :controller => 'admin/brand',
#          :action => 'edit',
#          :id => id,
#          :return_controller => 'admin/quick_entry',
#          :return_action => 'brand_created'
#      end
#    else
#      render :nothing => true
#      return false
#    end
#  end
#
#  def edit_wine
#    id = SelectByTextController.get_param_id(params[:wine_t])
#    if id.nil?
#      c = Wine.find_by_name(params[:wine_t][:name])
#      if c
#        id = c.id
#      end
#    end
#    if id
#      render :update do |page|
#        page.redirect_to :controller => 'admin/wine',
#          :action => 'edit',
#          :id => id,
#          :return_controller => 'admin/quick_entry',
#          :return_action => 'wine_created'
#      end
#    else
#      render :nothing => true
#      return false
#    end
#  end
#
#  def wine_country_created
#    object_created 'set_defaults_for_wine_country', WineCountry
#  end
#
#  def region_created
#    object_created 'set_defaults_for_region', Region
#  end
#
#  def winery_created
#    object_created 'set_defaults_for_winery', Winery
#  end
#
#  def brand_created
#    object_created 'set_defaults_for_brand', Brand
#  end
#
#  def wine_created
#    object_created 'set_defaults_for_wine', Wine
#  end
#
#  def winery_details
#    id = params[:winery_id]
#    if id.blank?
#      render :text => ''
#    else
#      winery = Merchandise.find_by_id(id)
#      winetypes_by_id, brands_by_winetype = init_brands_by_winetype(winery)
#      render :partial => 'shared/brands_by_winetype', :locals => {
#        :winery => winery,
#        :brands_by_winetype => brands_by_winetype,
#        :winetypes_by_id => winetypes_by_id,
#        :return_controller => 'admin/quick_entry',
#        :return_action => 'brand_created'
#      }
#    end
#  end
  
  protected
  def init_menu
    @menu = [:admin, :quick_entry]
  end

  private
#  def object_created meth, obj
#    id = params[:id]
#    if id.blank?
#      redirect_to :action => 'index'
#    else
#      defaults = {}
#      inst = obj.send('find_by_id', id)
#      send meth, defaults, inst
#      redirect_to defaults.merge(:action => 'index')
#    end
#  end
#
#  def set_defaults_for_continent defaults, cont
#    defaults[:continent_id] = cont.id
#    defaults[:continent_name] = cont.name
#    defaults[:continent_name_for_id] = cont.name
#  end
#
#  def set_defaults_for_wine_country defaults, ctr
#    defaults[:country_id] = ctr.id
#    defaults[:country_name] = ctr.name
#    defaults[:country_name_for_id] = ctr.name
#    set_defaults_for_continent defaults, ctr.continent
#  end
#
#  def set_defaults_for_region defaults, reg
#    defaults[:region_id] = reg.id
#    defaults[:region_name] = reg.name
#    defaults[:region_name_for_id] = reg.name
#    set_defaults_for_wine_country defaults, reg.wine_country
#  end
#
#  def set_defaults_for_winery defaults, win
#    defaults[:winery_id] = win.id
#    defaults[:winery_name] = win.name
#    defaults[:winery_name_for_id] = win.name
#    set_defaults_for_region defaults, win.region
#  end
#
#  def set_defaults_for_brand defaults, brand
#    defaults[:brand_id] = brand.id
#    defaults[:brand_name] = brand.name
#    defaults[:brand_name_for_id] = brand.name
#    set_defaults_for_winery defaults, brand.winery
#  end
#
#  def set_defaults_for_wine defaults, wine
#    defaults[:wine_id] = wine.id
#    defaults[:wine_name] = wine.name
#    defaults[:wine_name_for_id] = wine.name
#    set_defaults_for_brand defaults, wine.brand
#  end

end
