# encoding: UTF-8
class BrandController < ApplicationController
 
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def new
    @brand = Brand.new
  end

  def index
    @brands = Brand.paginate :page => params[:page], :per_page => 5, :order => 'name'
  end

  def update_tab
    tab = params[:tab].to_i
    @brands = Brand.paginate :page => params[:page], :per_page => 5, :order => 'name'
    if tab == 1 or tab == 0
      partial = 'list'
    elsif tab == 2
      partial = 'listof'
    elsif tab == 3
      partial = 'list'
    end
    render :update do |page|
      page.replace_html 'sort', :partial => '/catalog/view_sort', :locals => {:tab => params[:tab]}
      page.replace_html 'brands', :partial => "/brand/" + partial
    end
  end

  def show
    @brand = Brand.find(params[:brand_id])
  end

  def create
    @brand = Brand.new(params[:brand])
    if @brand.save
      ImageOwner::save_pictures @brand, params[:uploaded_picture], params[:uploaded_picture_link], params
      flash[:notice] = 'Сохранение прошло успешно'
      redirect_to :action => 'show', :brand_id => @brand.id
    else
      render :action => 'new'
    end
  end

  def edit
    @brand = Brand.find(params[:id])
  end

  def update
    @brand = Brand.find(params[:id])
    if @brand.update_attributes(params[:brand])
      ImageOwner::save_pictures @brand, params[:uploaded_picture], params[:title], params
      flash[:notice] = 'Все изменения сохранены успешно'
      redirect_to :action => 'show', :brand_id => @brand.id
    else
      render :action => 'edit'
    end
  end

  def destroy
    Brand.find(params[:id]).destroy
    redirect_to :action => 'index'
  end

  def delete_picture
    @brand = Brand.find(params[:brand_id])
    ImageOwner::delete_picture params[:id], @brand
    render :action => 'edit',:id => params[:id]
  end

  protected
  def init_menu
    @menu = [:brand]
  end
end
