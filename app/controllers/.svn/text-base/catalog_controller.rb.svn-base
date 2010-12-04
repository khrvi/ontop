class CatalogController < ApplicationController

  def index
    distr = City.find(1).districts.map(&:id)
    list_of_companies = AddressByDate.find_all_by_district_id(distr).map(&:company)
  
    @alph_array = []
    @list_names = []
    string_of_letters = ''
    @rus_alph_array = []
    list_of_companies.each do |r|
      if r.name[0..1].to_s > 'z'.to_s
        @rus_alph_array << r.name[0..1]
      else
        string_of_letters << r.name[0]
      end
    end
  
    @alph_array = string_of_letters.split(//)
    @alph_array.uniq!
    @alph_array.sort!
  
    @rus_alph_array.sort!
  
    @list_names = list_of_companies.map(&:name)
    @list_names.sort!
  end

  def change_company
    @company = Company.find(params[:company_id])
    render :update do |page|
      page.replace_html 'categories', :partial => 'category_field'
    end
  end

  def list_up_down
    pic = params[:flag] ? '/images/background/plus.gif' : '/images/background/minus.gif'
    render :update do |page|
      page.visual_effect :toggle_blind, "div1_" + params[:id]
      page.replace_html 'link1_' + params[:id], :partial => "/shared/link_pic", :locals => {:pic => pic,
                                                                                :item =>params[:id],
                                                                                :fl => !params[:flag],
                                                                                :contr => params[:contr]}
    end
  end
  
  def update_tab
    tab = params[:tab].to_i
    if tab == 1 or tab == 0
      partial = '/admin/merchandise/merchandise_table' 
      @merchandise = Merchandise.list_with_pagination(params[:page], 10)
    elsif tab == 2
      @merchandise = Merchandise.list_with_pagination(params[:page], 20)
      partial = '/admin/merchandise/merchandise_image'
    elsif tab == 3
      @merchandise = Merchandise.list_with_pagination(params[:page], 30)
      partial = '/admin/merchandise/merchandise_list'
    end
   
    render :update do |page|
      page.replace_html 'sort', :partial => 'view_sort', :locals => {:tab => params[:tab]}
      page.replace_html 'merchandises', :partial => partial, :locals => {:category_id => params[:category_id]}
    end
   
  end

  def update_merch
    #TODO:Выбирать только товары для данной фирмы и категории
    @category = params[:category_id]
    @company = params[:company_id]
    @merchandise = Merchandise.list_with_pagination(params[:page], 10)
    render :update do |page|
      page.replace_html 'sort', :partial => 'view_sort', :locals => {:tab => 1}
      page.replace_html 'merchandises', :partial => '/admin/merchandise/merchandise_table', :locals => {:page => params[:page],:category_id => params[:category_id] }
    end
  end
  
  protected
  def init_menu
    @menu = [:catalog]
  end
end
