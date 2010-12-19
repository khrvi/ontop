# encoding: UTF-8
include ImageOwner
class ProfileController < ApplicationController

  def index
    redirect_to :action => 'show'
  end

  def show
    @menu = [:profile, :show]
    user = User.current_user
    cr = Company.find_by_actor_id(user.actor_id)

    if cr
      session[:company] = cr.id
      @graph = open_flash_chart_object(400,250, '/profile/pie_links', false, '/')
      @company = Company.find_by_actor_id(user.actor_id)
    else
      c = CustomCompanyName.find_by_actor_id(user.actor_id)
      @company = c ? Company.find(c.company_id) : nil
    end

  end

  #Update table Person - > Edit Personal information
  def update
    @actor = Actor.find(params[:id])
    @user = User.find_by_actor_id(@actor.id)
    @person = Person.find_by_actor_id(@actor.id)

      person = params[:person]

    if @person.update_attributes(person) #&& @user.update_attributes(params[:user])
      #save_address_by_date @person.actor
      ImageOwner::save_pictures @person, params[:path], params[:uploaded_picture_link], params

      flash[:notice] = 'Изменения выполнены успешно'
      redirect_to :action => 'show'
    else
      person = params[:person]
      render :action => 'edit_person'
    end
  end

  def destroy
    comp = Company.find_by_actor_id(User.find(params[:id]).actor_id)
    id = comp.id
    unless comp.nil?
      flash[:notice]  = "Компания #{comp.name} успешно удалена. "
      #Delete all images for this company
      PictureCompany.find_all_by_company_id(id).each {|q|
         Picture.find(:first, q.picture_id).destroy
      }
      PictureCompany.delete_all "company_id = #{comp.id}"

       AddressByDate.find_all_by_company_id(id).each {|t|
         t.destroy
         p " AdressByDate - destroy"
         }

      #Delete all users of the company
      CustomCompanyName.find_all_by_company_id(id).each {|q|
         User.find_by_actor_id(q.actor_id).destroy
         Actor.find(q.actor_id).destroy
         q.destroy
      }

      comp.destroy
    else
      flash[:error]  = "Компания может быть удалена только её создателем. "
    end
    redirect_to :action => 'show'
  end








  def location_change
    render :update do |page|
      page.replace_html 'city' + params[:div], :partial => '/shared/location_change', :locals => {:district_id => params[:id],:obj => params[:div],  :answer_ajax => true}
   #   page.replace_html 'dis' + params[:div], :partial => '/shared/location_change', :locals => {:district_id => params[:id],:obj => params[:div],  :answer_ajax => true}
      page.call 'hide_modal_dialog'  
    end
  end
  
  def destroy_main_user
   # remote_function (:url => {:controller => "admin/person", :action => 'destroy'},:id => params[:id], :path => '/')
  end
   
  def pie_links
    category_hash = {}
    CompanyCategory.find_all_by_company_id(session[:company]).each do |q|
      cat = Category.find_by_id(q.category_id)
      category_hash[cat.name] = cat.id 
    end
    a = []
    category_hash.each do |q,e|
      Merchandise.find_all_by_category_id(e).each {|w|  a << w.id}
    end
    mercomp_pr =  PriceByDate.find_all_by_merchan_id(a, :conditions => ["company_id=?",session[:company]])
    
    mer_hash = {}
    mercomp_pr.each do |q|
      if mer_hash.has_key? q.merchan_id
        if mer_hash[q.merchan_id] < q.created_at
          mer_hash[q.merchan_id] = q.created_at
        end
      else 
        mer_hash[q.merchan_id] = q.created_at
      end 
    end
    
    result = {}
    mer_hash.each do |w,q|
      cat = Merchandise.find_by_id(w).category_id
      result.has_key?(cat) ? result[cat] += 1 : result[cat] = 1 
    end
   
    data = []
    links = []
    mer_c = []
    result.each do |t,y|
      mer_c << Category.find_by_id(t).name
      data << (y*100)/mer_hash.length 
      links << "/admin/company"
    end

    g = Graph.new
    g.pie(60, '#505050', '#000000')
    g.pie_values(data, mer_c, links)
    g.pie_slice_colors(%w(#d01fc3 #356aa0 #c79810 #a010c3 #7999a0 #810910))
    g.set_tool_tip("#val#%")
    g.title("Товары и категории", '{font-size:18px; color: #d01f3c}' )
    render :text => g.render
  end
  
  def back
    File.delete(session[:path])
    redirect_to :action => "show"
  end
  

  
  def del
    Picture.find(params[:id]).destroy
    unless params[:person_id].nil?
      PicturePerson.delete_all "picture_id = #{params[:id]} and person_id = #{params[:person_id]}"
      # @brand = Brand.find(params[:brand_id])
        
      uid = User.find_by_actor_id(Person.find(params[:person_id]).actor_id).id
      @user = User.find_by_id(uid)
     
      @actor = @user.actor
      @person = @actor.person
      @roles = Role.find(:all)
      if @person.actor_id
        @person.actor.address_by_dates.each do |ad|
          var_name = "@address_by_date_" + ad.id.to_s
          instance_variable_set(var_name, ad)
        end
      end
      @address_by_date_0 = AddressByDate.new
      render :controller => "/profile",:action => 'edit',:user_id => User.find_by_actor_id(Person.find(params[:person_id]).actor_id).id
    end 
  end
  
  def add_parameters
    @category_id = params[:id].to_i
    @array_names = []
    @array_desc = []
    @count = 1
  end
  
  def save_parameters_for_category
    #names = MerchandiseColumnName.find_all_by_category_id(params[:category1].to_i)
    0.upto(params[:count1].to_i-1) do |a|
      param_new = MerchandiseColumnName.new(:category_id => params[:category1],
                                            :column_name => params[:category][:"name_#{a.to_s}"],
                                            :description => params[:category][:"desc_#{a.to_s}"]
                                            )
      flash[:nitice] = "Данные сохранены успешно" if param_new.save
    end
    redirect_to :action => "add_category"
  end
  
  def edit_category
    names = MerchandiseColumnName.find_all_by_category_id(params[:category1].to_i)
    0.upto(params[:count1].to_i-1) do |a|
      if names.length > a
        names[a].update_attributes(:column_name => name)
        names[a].update_attributes(:description => desc)
      else
        param_new = MerchandiseColumnName.new(:category_id => params[:category1],
                                               :column_name => params[:category][:"name_#{a.to_s}"],
                                               :description => params[:category][:"desc_#{a.to_s}"]
                                               )
        flash[:nitice] = "Данные сохранены успешно" if param_new.save
      end 
    end
    redirect_to :action => "add_category"
  end
  
  def delete_category
    cat = Category.find_by_id(params[:id])
    if cat.created_by == current_user.login.to_s or current_user.login.to_s == 'admin'
      flash[:notice] = "Категория " + cat.name.to_s + " успешно удалена"
      cat.destroy
    else
      flash[:error] = "Вы не можете удалить данную категорию, т.к. она создана другим польователем!"
    end
  end
  
  def delete_my_category
    cat = Category.find_by_id(params[:id])
    comcat = CompanyCategory.find_by_category_id(cat)
    flash[:notice] = "Категория " + cat.name.to_s + " успешно удалена"
    comcat.destroy
  end
    
  def view_category
    t = MerchandiseColumnName.find_all_by_category_id(@category_id.to_i)
    t.length > 0 ? @count = t.length : @count = 0
  
    @array_names = []
    @array_desc = []
    t.each do |q|
      @array_names << q.column_name
      @array_desc << q.description
    end
  
    render :update do |page|
      page.replace_html 'list', :partial => 'parameters_field' , :locals => {:create_new_mer => false}
    end
  end 
  
  def category_param
    @array_names = []
    @array_desc = []
    @count = 0
  end
  
  def add_param 
    @array_names = []
    @array_desc = []
    @category_id = params[:category]
    t = MerchandiseColumnName.find_all_by_category_id(@category_id)
    t.each do |q|
      @array_names << q.column_name
      @array_desc << q.description
    end
    @count = params[:count].to_i + 1
   
    render :update do |page|
      page.replace_html 'list', :partial => 'parameters_field', :locals => { }
    end
  end
  
  def create_cat
    str = "add_category"
    str = "add_parameters" if params[:last]
    cat = Category.new
   
    if params[:category][:parent_category_id].nil?
      cat.parent_category_id = nil
    else
      cat.parent_category_id = params[:category][:parent_category_id]
    end
    cat.name = params[:category][:name]
    cat.category_comment = params[:category][:category_comment]
    unless cat.save
      flash[:error] = "ERROR"  
    end
    redirect_to :action => str, :id => cat.id
  end
  
  def todo_complited
    update_todo_completed_date
  end
  
  def todo_pending
    delete_todo
  end
  
  def sort_todos
  end

  def upload
  end
  
  def add_catalog
    table_com_cat = {}
    company_id = Company.find_by_actor_id(User.find(session[:user]).actor_id).id
    CompanyCategory.find_all_by_company_id(company_id).each {|q| q.destroy}
    content = ''
    f = File.open(session[:path],"r")
  
    content = f.read()
    f.close
    File.delete(session[:path])
    session[:path] = nil
    a = 0
    array1 = Array.new
      FasterCSV.parse(content) do |row|
        f = true
        if a!=0
          0.upto(a-1) do |r|
            if array1[r].to_i == Category.find_by_id(row[0]).id
              f = false
            end
          end  
        end
       
        if f
          array1[a] = Category.find_by_id(row[0]).id
          a += 1
        end    
      end
    
    array1.each do |q|
      CompanyCategory.find(:all).each {|c| table_com_cat[c.category_id] = c.company_id}
      unless table_com_cat.has_key? q and table_com_cat[q] == Company.find_by_actor_id(User.find(session[:user]).actor_id).id
        com = CompanyCategory.new
        com.company_id = company_id
        com.category_id = q
        com.save
      end
    end
    redirect_to :action => 'show'
  end
  
  def add_company
    @company = Company.new 
    @address_by_date = AddressByDate.new  
  end
  
  def add_category 
    array = []
    file_name = rand(100000)
    tmpFile = Tempfile.new(file_name.to_s)
    path= tmpFile.path
    tmpFile.close(true)

    f = File.new(path,"w")
    f.close
    session[:path] = path
    company_id = Company.find_by_actor_id(User.find(session[:user]).actor_id).id
    
    comcat = CompanyCategory.find(:all, :conditions => ["company_id=?",company_id])
    comcat.each {|d| array << d.category_id }
	  ctgr = Category.find(array, :order => 'name')
    #Open file and add a new item(category) 
    f = File.open(path,"a+")
    # a = Category.find_by_id(params[:todo])
    comcat.each do |q| 
      str =  q.category_id.to_s+"\n"
      f.write(str)
    end
    
    f.close 
    @company = company_id
  end
  
  #Add new company informations
  def add_comp
    @company = Company.new(params[:company])
    if @company.save 
      @company.address_by_dates.each do |ad|
      if params[('delete_address_by_date_' + ad.id.to_s).to_sym].blank?
        if ad.update_attributes params['address_by_date_' + ad.id.to_s]
          path = 'show'
        else
          flash[:error] = 'Существующий(е) адрес(а) не был(и) изменен(ы), проверьте правильность ввода информации. '
          path = 'edit_company'
        end 
      else
        ad.destroy
      end
    end
    pnew = params[:address_by_date_0]
      all_blank = true
      [:name, :address_line_1, :address_line_2, :address_line_3, :address_line_4,
       :zip_code, :city, :state, :country].each do |f|
        unless pnew[f].blank?
          all_blank = false
        end
       end
      unless all_blank
        pnew[:company_id] = @company.id
        @address = AddressByDate.new pnew
      
        if @address.save
       
          path = 'show'
          ImageOwner::save_pictures @company, params[:path], params[:uploaded_picture_link], params
           current_user.has_role 'datamanager'
           current_user.has_role 'user'
          flash[:notice] = 'Новый адрес был успешно сохранён'
        else
           path = 'edit_company' 
           flash[:error] = 'Новый адрес не может быть сохранен. Корректно введите информацию в обязательные поля.' 
        end
      end
   
      redirect_to :action => path ,:user_id => params[:company][:actor_id]#, :company => params[:company]
   
    else
      render :action => 'add_company', :user_id => params[:company][:actor_id]
    end
  end
  
  #Before show a page 'edit_company'
  def edit_company
     @company = Company.find_by_actor_id(@current_user)
     @address = @company.address_by_dates
  end
  

  
  def change_district_js
    render :update do |page|
       page.replace_html 'district_' + params[:obj], :partial => "/shared/district_select", :locals => {:id => params[:id], :obj_id => params[:obj]}
    end
  end
  
  #Before show a page 'add_person'
  def add_person
      
    @menu = [:profile, :edit]
    uid = params[:user_id]
    @user = User.find_by_id(uid)
    if @user.nil?
      flash[:error] = 'Пользователь не найден'
      redirect_to :action => 'show', :user_id => params[:user_id]
      return
    end
    @actor = @user.actor
    @person = @actor.person
#    @person.actor_id = @actor.id
    @roles = Role.find(:all)
      
  end
  
  #Before show a page 'edit_person'
  def edit_person
  
    @menu = [:profile, :edit]
    uid = params[:user_id]
    @user = User.find_by_id(uid)
    if @user.nil?
      flash[:error] = 'Пользователь не найден'
      redirect_to :action => 'show', :user_id => params[:user_id]
      return
    end
    @actor = @user.actor
    @person = @actor.person
    #@person.actor_id = @actor.id
    @roles = Role.find(:all)
#    if @person.actor_id
#      @person.actor.address_by_dates.each do |ad|
#        var_name = "@address_by_date_" + ad.id.to_s
#        instance_variable_set(var_name, ad)
#        #eval "#{var_name} = #{wn}"
#      end
#    end
#    @address_by_date_0 = AddressByDate.new
  end
  
  #Add new personal information
  def person_create
    
    @actor = Actor.find(params[:id])
    @user = User.find_by_actor_id(@actor.id)
    @person = Person.new(params[:person])
    @person.actor_id = @actor.id
      #person = params[:person]
     if @person.save
      ImageOwner::save_pictures @person, params[:path], params[:uploaded_picture_link], params
      flash[:notice] = 'Изменения выполнены успешно'
      redirect_to :action => 'show'
     else
      person = params[:person]
      render :action => 'add_person'
     end
  end
  


  #Update table Company and AddressByDate -> Edit company informations
  def update_comp
    @company = Company.find_by_actor_id(params[:company][:actor_id])
    if @company.update_attributes(params[:company]) 
      
      @company.address_by_dates.each do |ad|
    
        if params[('delete_address_by_date_' + ad.id.to_s).to_sym].blank?
          if ad.update_attributes params['address_by_date_' + ad.id.to_s]
          
          path = 'show'
          else
          flash[:error] = 'Существующий(е) адрес(а) не был(и) изменен(ы), проверьте правильность ввода информации. '
            path = 'edit_company'
          end 
        else
          ad.destroy
        end
      end
   
      pnew = params[:address_by_date_0]
     
      all_blank = true
      [:name, :address_line_1, :address_line_2, :address_line_3, :address_line_4,
       :zip_code, :city, :state, :country].each do |f|
        unless pnew[f].blank?
          all_blank = false
        end
       end
      unless all_blank
        pnew[:company_id] = @company.id
        @address = AddressByDate.new pnew
      
        if @address.save
       
          path = 'show'
          ImageOwner::save_pictures @company, params[:path], params[:uploaded_picture_link], params
          flash[:notice] = 'Новый адрес был успешно сохранён'
        else
           path = 'edit_company' 
           flash[:error] = 'Новый адрес не может быть сохранен. Корректно введите информацию в обязательные поля.' 
        end
      end
   
      redirect_to :action => path ,:user_id => params[:user_id]
    else
    
     @company.address_by_dates.each do |ad|
        var_name = "@address_by_date_" + ad.id.to_s
        instance_variable_set(var_name, ad)
        #eval "#{var_name} = #{wn}"
      end
  
    #@address_by_date_0 = AddressByDate.new
      #flash[:error] = 'Изменения не были сохранены!'
      @address_by_date = AddressByDate.new  
      render :action => 'edit_company'
    end
  end

  def change_password
    @menu = [:profile, :change_password]
  end
  
  def update_password
    if params[:old_password].blank? || params[:new_password].blank? || params[:confirm_new_password].blank?
      flash[:error] = 'Пожалуйста, заполните все поля'
      redirect_to :action => 'change_password'
      return
    end
    unless @current_user.authenticated? params[:old_password]
      flash[:error] = 'старый пароль указан не верно'
      redirect_to :action => 'change_password'
      return
    end
    unless params[:new_password] == params[:confirm_new_password]
      flash[:error] = 'Новый пароль не подтверждён'
      redirect_to :action => 'change_password'
      return
    end
    @current_user.password = params[:new_password]
    @current_user.password_confirmation = params[:confirm_new_password]
    @current_user.save!
    flash[:notice] = 'Пароль изменён'
    redirect_to :action => 'show'
  end
  
  protected
  def init_menu
    @menu = [:profile]
  end
  
  private
  def update_todo_completed_date
    # "**************************************************************"
    path = session[:path]
    #Open file and add a new item(category) 
    f1 = File.open(path,"a+")
      a = Category.find_by_id(params[:todo])
      str =  params[:todo]+"\n"
      f1.write(str)
    f1.close 
    
    #Read a content of the file to the variable 'content'
    content = ""
    f1 = File.open(path,"r")
      file_content = f1.read()
    f1.close
    file_content.each do |a|
       content << a
    end
    # "**************************************************************"
    array1 = []
    a = 0 
      #Open temporary file and read category_id from it 
     FasterCSV.parse(content) do |row|
     # "**************************************************************"
        f = true
        if a!=0
          0.upto(a-1) do |r|
        
            if array1[r].id.to_i == Category.find_by_id(row[0]).id
              f = false
            end
          end  
        end
      
        if f
          array1[a] = Category.find_by_id(row[0].to_i)
          p array1[a].id.to_s
          parent_id = Category.find_by_id(array1[a].parent_category_id)
          temp_table = {}
          # "**************************************************************"
          # Add all parent categories, if parent categories is exists
          unless parent_id.nil?
            f1 = File.open(path,"a+")
             
            while parent_id.parent_category_id != nil do
            
               array1.each {|c| temp_table[c.id] = c.id}
               unless temp_table.has_key? parent_id.id
                 a+=1
                 array1[a] = parent_id
                 str = array1[a].id.to_s + "\n"
                 f1.write(str)
               end
               parent_id = Category.find_by_id(parent_id.parent_category_id)
              
            end  
           
            array1.each {|c| temp_table[c.id] = c.id}
              unless temp_table.has_key? parent_id.id
                   a+=1
                  array1[a] = parent_id
                  p  str = array1[a].id.to_s + "\n"
                   f1.write(str)
              end
              f1.close 
              a+=1
              
          end    
          # "**************************************************************"
        end
            
     end
     
     company_id = Company.find_by_actor_id(User.find(session[:user]).actor_id).id
     render :update do |page|
       page.replace_html 'completed', :partial => '/catalog/categories', :locals => {:list => array1,:company_id => company_id}
     end
  end
  
  
  def delete_todo
   Temp.find_by_id(params[:todo].to_i).destroy
  end
  
end
