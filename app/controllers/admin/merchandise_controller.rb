class Admin::MerchandiseController < Admin::AbstractAdminController

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def index
    list
    render :action => 'list'
  end

  def list
   @merchandise = Merchandise.find(:all)
  end

  def update_merch
    @category = params[:category_id]
    @merchandise = Merchandise.find(:all)
    render :update do |page|
      page.replace_html 'merchandises', :partial => 'merchandise_table', :locals => {:text => "fff"} 
    end
  end
  
  def new
    @merchandise = Merchandise.new
    @array = []
    @flag_new = true 
  end

  def create
    @merchandise = Merchandise.new(params[:merchandise])
    if @merchandise.save
      ImageOwner::save_pictures @merchandise, params[:path], params[:uploaded_picture_link], params
      save_merchandise_names @merchandise
      
      save_merchandise_price params[:price][:currency_id],params[:price][:amount],@merchandise.id,params[:price_by_date][:quantity]
      flash[:notice] = 'Новый товар успешно добавлен'
      redirect_to :controller => "/profile", :action => 'show'
    else
      render :action => 'new'
    end
  end

  def edit
    @merchandise = Merchandise.find(params[:id])
    @hash = {}
    @array = []
    @flag_new = false 
    column = MerchandiseColumnName.find_all_by_category_id(@merchandise.category_id)
    column1 = MerchandiseColumnDesc.find_all_by_merchan_id(@merchandise.id) 
    step_array = 0
    sequence = 0
    column.each do |q|
	    @array[step_array] = q.column_name
	    @array[step_array+1] = column1[sequence].column_value
	    step_array += 2
	    sequence += 1
	  end
  end

  def update
    @merchandise = Merchandise.find(params[:id])
    if @merchandise.update_attributes(params[:merchandise])
      update_merchandise_names @merchandise
      PictureMerchandise.find_all_by_merchandise_id(@merchandise.id).each do |q|
        del_merchandise_pictures(q) if params[:"p_#{q.picture_id.to_s}"]
      end
      flash[:notice] = 'Все изменения были успешно добавлены'
      redirect_to :controller => "/catalog"
    else
      render :action => 'edit'
    end
  end

  def destroy
    merchandise = {}
    Merchandise.find(params[:id]).destroy
    MerchandiseColumnDesc.find_all_by_merchan_id(params[:id]).each {|q| q.destroy }
    #Надо пробовать завязывать удаление по ассоциации
    PictureMerchandise.find_all_by_merchandise_id(params[:id]).each {|q| del_merchandise_pictures(q)}
    flash[:notice] = "Информация о товаре удалена успешна"
    redirect_to :controller => '/catalog'
  end

  def category_selected
    category_id = params[:category_id]
    if category_id.blank?
      category_id = category = nil
    else
      category = Category.find_by_id(category_id)
    end
    render :update do |page|
      page.replace_html 'category', :partial => 'category_details', :locals => {:category_id => category_id, :category => category, :answer_ajax => true} 
      page.call 'hide_modal_dialog'
    end
  end

  def category_selected_merchandise
    category_id = params[:category_id]
    if category_id.blank?
      category_id = category = nil
    else
      category = Category.find_by_id(category_id)
    end
   
    render :update do |page|
      page.replace_html params[:name_combo], :partial => 'category_selection', :locals => {:name_combo => params[:name_combo],:category_id => category_id, :category => category, :answer_ajax => true}
      page.call 'hide_modal_dialog'
    end
  end
  
  
  def get_category_id(root)
    root.kind_of?(Company) ? nil : root.id
  end
  
  def get_country_id(root)
    root.kind_of?(Company) ? root.id : root.company_id
  end
  
#  private
#  def save_merchandise_parameters merchandise
#    names = MerchandiseColumnName.find_all_by_category_id(merchandise.category_id)
#    values = MerchandiseColumnDesc.find_all_by_merchan_id(merchandise.id)
#    amount = values.length
#    
#    array = Array.new
#    
#    0.upto(amount-1) do |q|
#      array[q] = params[:row][:"#{q.to_s}"]
#      p params[:row][:"#{q.to_s}"]
#      values[q].update_attributes(:column_value =>array[q])
#    end
#  end

 
  private
  def del_merchandise_pictures pic
    PictureMerchandise.delete_all "picture_id = #{pic.picture_id}"
    Picture.delete(pic.picture_id)
  end

  protected
  def init_menu
    @menu = [:admin, :merchandise]
  end
  
  def save_merchandise_names merch
    column = MerchandiseColumnName.find_all_by_category_id(merch.category_id)
    column.each do |q|
      m = MerchandiseColumnDesc.new
      m.column_value = params[:"#{q.column_name}"]
      m.merchan_id = merch.id
      m.save
    end  
  end

  def save_merchandise_price (currency,amount,merchandise_id,quantity)
    price = Price.new
    price.currency_id = currency
    price.amount = amount
    price.save
              
    priceby = PriceByDate.new
    priceby.company_id = Company.find_by_actor_id(User.find(session[:user].to_i).actor_id).id
    priceby.merchan_id = merchandise_id
    priceby.quantity = quantity
    priceby.price_date = Time.now
    priceby.price_id = price.id
    priceby.save
  end

  def update_merchandise_names merch
    column = MerchandiseColumnName.find_all_by_category_id(merch.category_id)
    m = MerchandiseColumnDesc.find_all_by_merchan_id(merch.id)
    a = 0
    # If category was changed then destroy all records from MerchandiseColumnDesc and save new records
    if column.length != m.length
      m.each do |e|
        e.destroy
      end
      column.each do |q|
        m = MerchandiseColumnDesc.new
        m.column_value = params[:"#{q.column_name}"]
        m.merchan_id = merch.id
        m.save
      end

    else
      column.each do |q|
        #m.column_value = params[:"#{q.column_name}"]
        m[a].update_attributes(:column_value => params[:"#{q.column_name}"])
        a += 1
      end
    end
  end
end
