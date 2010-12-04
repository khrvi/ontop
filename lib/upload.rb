require 'faster_csv'
module Upload
  #List of methods
  #-upload_file
  #-save(attr)
  #-check(arr)
  #-hash_create(arr)
  #-save_categories(arr)
  #-del_file
  #-save_all   : Company   
  #-create_combo(temp_hash,tmp_file) :Merchandise
  
#*******************Profile************************************  
  def upload_file
      ignore = params[:ignore]
      error = false
      content = ''
      array_error = []
      amount = 0
      file_content = params[:file]
      if file_content.blank?
        flash[:error] = "Пожалуйста выберите CSV файл с данными"
        action = 'upload'
      else
        file_content.each do |a|
          content << a
        end
        file_first_string = true
        begin
          FasterCSV.parse(content) do |row|
            # Ignore the first string
            if file_first_string
              file_first_string = false
            else
              unless row[0]==nil and row[1].nil? and row[2].nil?
                if !row[0].nil? and row[1].blank? and row[2].blank?
                  cat = Category.find_by_name(row[0].to_s)
                  if cat.nil?
                    #flash[:error] = "В загружаемом файле присутствуют категории не найденные в базе данных!"
                    array_error << "Категория " + row[0] + ' не найденные в базе данных!'
                    error = true
                    #action = 'upload'
                  else
                    comp_id = Company.find_by_actor_id(User.find(session[:user].to_i).actor_id).id
                    exist = CompanyCategory.find(:all, :conditions => ["company_id=? and category_id=?",comp_id,cat.id])
                    if exist.length == 0
                      array_error << "Категория " + row[0] + ' не используется вашей компанией!'
                      error = true
                    end
                  end
                else
                  amount += 1
                  if row[0].nil?
                    array_error << "Выберите файл формата CSV!"
                    error = true
                  end
                end
              end
            end
          end
        rescue => error
          array_error = Array.new
          array_error << error
          error= true
        end

        if error and not ignore
          redirect_to :action => 'upload', :er => error, :errors => array_error, :amount => amount
          return
        else
          brands = {}
          Brand.find(:all).each {|c| brands[c.name] = c.id}

          exist_new_item = true#false
          file_first_string = true
          FasterCSV.parse(content) do |row|
            # Ignore the first string
            if file_first_string
              file_first_string = false
            else
              unless row[0].blank?
                row[0].strip!
                unless  row[1].nil?
                  row[1].strip!
                end
                unless  row[2].nil?
                  row[2].strip!
                end
  #              unless brands.has_key? row[0]
  #                exist_new_item  = true
  #              end
              end
            end
          end

          if exist_new_item
            str = save(content)
            array_error << str
          else
            array_error << "Все брэнды из файла уже существуют в базе данных!"
            #str ="Все брэнды из файла уже существуют в базе данных!"
          end
        end
      end
      redirect_to :action => 'upload', :er => error ,:errors => array_error, :amount => amount
    end

    def save(arr)
      brands = {}
      Brand.find(:all).each {|c| brands[c.name] = c.id}
      ignore = true
      fl = 0
      file_first_string = true
      category_id = nil
      FasterCSV.parse(arr) do |row|
        # Ignore the first string
        if file_first_string
          file_first_string = false
        else
          brands = {}
          Brand.find(:all).each {|c| brands[c.name] = c.id}
          #String with name ot the category
          if !row[0].nil? and row[1].blank? and row[2].blank?
            ignore = true
            row[0].strip!
            category_id = Category.find_by_name(row[0].to_s)
            #If category not exist
            if category_id.nil?
              ignore = false
            else
              #if category is not used for this company
              comp_id = Company.find_by_actor_id(User.find(session[:user].to_i).actor_id).id
              exist = CompanyCategory.find(:all, :conditions => ["company_id=? and category_id=?",comp_id,category_id.id])
              if exist.length == 0
                ignore = false
              end
            end
          else
            #String with name of merchandise
            #If category ignored then 'ignore' = false
            if !row[1].nil? and !row[0].nil? and ignore
               p "CATEGORY=" + category_id.id.to_s
            #  unless brands.has_key? row[0]
                row[0].strip!
                row[1].strip!
                unless row[2].nil?
                  row[2].strip!
                end
              unless row[3].nil?
                  row[3].strip!
                end
              unless row[4].nil?
                  row[4].strip!
                end

                price = Price.create(:currency_id => row[4],
                                      :price.amount => row[3])
                priceby = PriceByDate.new
                priceby.company_id = Company.find_by_actor_id(User.find(session[:user].to_i).actor_id).id
                mer = Merchandise.find_by_name(row[1])

                if mer.nil?
                  merch = nil
                else
                  merch = mer.name
                end
                brand = Brand.find_by_name(row[0])
                if brand.nil?
                  brand_id = nil
                else
                  brand_id = brand.id
                end
                merchandise = Merchandise.find(:first, :conditions => ["category_id=? and brand_id=? and name=?",category_id.id,brand_id, merch ])

                # If merchandise is not exists
                if merchandise.nil?
                  mer = Merchandise.new
                  mer.name = row[1]

                  brand = Brand.create(:name => row[0]) if brand_id.nil?
                  mer.brand_id = brand.id
                  #cat = Category.find_by_name(row[0].to_s)
                  mer.category_id = category_id.id #cat.id
                  mer.checked = false
                  mer.save

                  priceby.merchan_id = mer.id
                else
                   priceby.merchan_id = merchandise.id
                end


  #              brand = Brand.find(mer.brand_id)
  #              if !brand.nil?
  #                priceby.merchan_id = mer.id
  #              end
                priceby.quantity = row[2]
                priceby.price_date = Time.now
                priceby.price_id = price.id
                priceby.save

    #            if brand.save
    #              fl = 1
    #              0.upto((row.length-4)/2) do |i|
    #                unless row[i*2+3].nil?
    #                  row[i*2+3].strip!
    #                  puts row[i*2+3]
    #                  title = row[i*2+4]
    #                  ImageOwner::upload_pictures brand, row[i*2+3], title
    #                end
    #              end
    #            else
    #              fl = 2
    #            end

             # end
            end
          end
        end
      end

      if fl == 2
        str = "Error"
      else
        str ="Данные добавлены" if fl == 1
      end
      return "Данные добавлены"
    end


#***********************Brand****************************  
   def upload_file
    error = false
    content = ""
    file_content = params[:file]
    if file_content.blank?
      flash[:error] = "Пожалуйста выберите CSV файл с данными"
      action = 'upload'
    else
      file_content.each do |a|
        content << a
      end

      begin
        FasterCSV.parse(content) do |row|
          unless row[0]==nil and row[1]==nil and row[2]==nil
            if row[0]==nil
              flash[:error] = "Выберите файл формата CSV!"
              action = 'upload'
              error = true
            end
          end
        end
      rescue => error
        flash[:error] = error
        action = 'upload'
        error= true
      end

      if not error

        brands = {}
        Brand.find(:all).each {|c| brands[c.name] = c.id}

        exist_new_item = false
        file_first_string = true
        FasterCSV.parse(content) do |row|
          # Ignore the first string
          if file_first_string
            file_first_string = false
          else
            unless row[0].blank?
              row[0].strip!
              unless  row[1].nil?
                row[1].strip!
              end
              unless  row[2].nil?
                row[2].strip!
              end
              unless brands.has_key? row[0]
                exist_new_item  = true
              end
            end
          end
        end

        if exist_new_item
          str = save(content)
        else
          str ="Все брэнды из файла уже существуют в базе данных!"
        end

        flash[:notice] = str
        action = "list"
      end
    end
    redirect_to :action => action

  end

  def save(arr)
    brands = {}
    Brand.find(:all).each {|c| brands[c.name] = c.id}

    fl = 0
    file_first_string = true

    FasterCSV.parse(arr) do |row|
      # Ignore the first string
      if file_first_string
        file_first_string = false
      else
        brands = {}
        Brand.find(:all).each {|c| brands[c.name] = c.id}
        unless row[1].blank? and row[0].blank?
          unless brands.has_key? row[0]
            row[0].strip!
            row[1].strip!
            unless row[2].nil?
              row[2].strip!
            end

            brand = Brand.new
            brand.name = row[0]
            #brand.shortname = row[2]
            brand.description = row[1]
            brand.site = row[2]


            if brand.save
              fl = 1
              0.upto((row.length-4)/2) do |i|
                unless row[i*2+3].nil?
                  row[i*2+3].strip!
                  puts row[i*2+3]
                  title = row[i*2+4]
                  ImageOwner::upload_pictures brand, row[i*2+3], title
                end
              end
            else
              fl = 2
            end

          end
        end
      end
    end

    if fl == 2
      str = "Error"
    elsif fl == 1
      str ="All countries has added successfully"
    end
    return str
  end


#************************Category******************************
   def check(arr)

    categories = {}
    Category.find(:all).each {|c| categories[c.name] = c.id}

#    countries = {}
#    Company.find(:all).each {|c| countries[c.name] = c.id}
    string_error = ''

    #Find a mistakes
    file_first_string = true
    FasterCSV.parse(arr) do |row|
      if file_first_string
        file_first_string = false
      else
       #unless row[1].blank? and row[0].blank?
#          unless categories.has_key? row[0]
#            if row[1].blank?
#              unless categories.has_key? row[2]
#              #  string_error << "Для категории " + row[0] + " не найдена родительская категория" + row[1] +  '<br>'
#              end
#            else
#              row[1].strip!
#              unless countries.has_key? row[1]
#                unless categories.has_key? row[2]
#                #  string_error << "The country " + row[1] + " not found in the database. Please set a new city for country " + row[0] + '<br>'
#                end
#              end
#            end
#          end
        #end
      end
    end
    # If mistakes are exists
    unless string_error.blank?
      # Create new temp file
      file_name = rand(100000)
      tmpFile = Tempfile.new(file_name.to_s)
      tmpFile.close(true)
      path = tmpFile.path
      f = File.new(path,"w")
      f.write(arr)
      f.close
    # Create a string for send to the page "result"
      str = hash_create(arr)
      create_combo(str,path,nil)
      return false
    end

  end

  def upload_file

    file_error = false
    arr = ''
    file_content = params[:file]
    # Check file contents for blank
    if file_content.blank?
      flash[:error] = "Please, select the CSV file to upload "
      action = 'upload'
    else
      #Copy contain of the file to string arr
      file_content.each do |aa|
        arr << aa
      end
      # Is contains of the file correct?
      begin
        FasterCSV.parse(arr) do |row|
          unless row[0]==nil and row[1]==nil
            if row[0]==nil
              flash[:error] = "Error, the first row equal nil. This file not correct. Select another file "
              action = 'upload'
              file_error = true
            end
          end
        end
      rescue => error
        flash[:error] = error
        action = 'upload'
        file_error = true
      end

      if not file_error
        categories = {}
        Category.find(:all).each {|c| categories[c.name] = c.id}
        countries = {}
        Company.find(:all).each {|c| countries[c.name] = c.id}

        new_data_exist = false
        file_first_string = true
        # Check for repeated data in the file
        FasterCSV.parse(arr) do |row|
          #Ignore the first string
          if file_first_string
            file_first_string = false
          else
          #  unless row[1].blank? and row[0].blank?
              row[0].strip!
              unless  row[1].nil?
                row[1].strip!
              end

              unless categories.has_key? row[0]
                new_data_exist = true
              end
           # end
          end
        end
        # If new data exist then check for error
        if new_data_exist
          if  check(arr) == false
            return
          end

           str = save_categories(arr)

        else
          str ="Все добавляемые категории уже существуют в базе данных"
        end

        flash[:notice] = str
        action = "index"
      end
    end
    redirect_to :action => action

  end

   def save
    unless params[:id].blank?
      category = Category.find_by_id(params[:id])
    else
      category = Category.new
    end
    [:company_id, :parent_category_id, :name,  :category_comment].each do |f|
      category.send f.to_s + '=', params[f]
    end
#    if category.sequence.nil?
#      if category.parent_category_id.nil?
#        cond = ['company_id=? and parent_category_id is null', category.company_id]
#      else
#        cond = ['company_id=? and parent_category_id=?', category.company_id, category.parent_category_id]
#      end
#      max_seq = 0
#      Category.find(:all, :conditions => cond).each do |r|
#        unless r.sequence.nil?
#          if r.sequence > max_seq then max_seq = r.sequence end
#        end
#      end
#      category.sequence = max_seq + 1
#    end
    category.save!
#    if params[:classification_ids]
#      category.classifications = Classification.find(params[:classification_ids])
#      category.save!
#    end
#    if params[:grape_ids]
#      category.grapes = Grape.find(params[:grape_ids])
#      category.save!
#    end
    redirect_to :action => 'index', :company_id => category.company_id
  end


  #  def hash_create(arr)
#
#    hash_sort = {}
#
#    categories = {}
#    Category.find(:all).each {|c| categories[c.name] = c.id}
#
#    countries = {}
#    Company.find(:all).each {|c| countries[c.name] = c.id}
#    file_first_string = true
#    FasterCSV.parse(arr) do |row|
#      #Ignore the first string
#      if file_first_string
#        file_first_string = false
#      else
#        unless row[1].blank? and row[0].blank?
#          if row[1].blank?
#            unless categories.has_key? row[2]
#              hash_sort[row[0]] = "nil"#row[1]
#            end
#          else
#            row[1].strip!
#            unless countries.has_key? row[1]
#              unless categories.has_key? row[2]
#                hash_sort[row[0]] = row[1]
#              end
#            end
#          end
#        end
#      end
#    end
#    # Hash => array
#    # Sort array by country
#    arr_sort = hash_sort.to_a.sort {|a,b| a[1]<=>b[1]}
#    # Array => string with comma separator
#    str = arr_sort.join(",")
#    return str
#
#  end


   def save_categories(arr)
    categories = {}
    categories_country = {}
    Category.find(:all).each {|c| categories[c.name] = c.id
    categories_country[c.name] = c.company_id}

    countries = {}
    Company.find(:all).each {|c| countries[c.name] = c.id}
    fl = 0
    file_first_string = true
    FasterCSV.parse(arr) do |row|
       # Ignore the first string
      if file_first_string
        file_first_string = false
      else
        categories = {}
        Category.find(:all).each {|c| categories[c.name] = c.id}
        unless row[1].blank? and row[0].blank?
          unless categories.has_key? row[0]
            row[0].strip!
            row[1].strip!
            category = Category.new
            category.name = row[0]

            if row[1].blank?
              if categories_country.has_key? row[2]
                row[1] = categories_country[row[2]]
                category.company_id = row[1]

              end

            else
              row[1].strip!
              if countries.has_key? row[1]
                category.company_id = countries[row[1]]

              else
                if categories_country.has_key? row[2]
                  row[1] = categories_country[row[2]]
                  category.company_id = row[1]

                end
              end
            end

            if row[2].blank? or row[2].nil?
              category.parent_category_id = nil
            else
              row[2].strip!
              category.parent_category_id = categories[row[2]]
            end

            unless row[3].nil?
              row[3].strip!
            end
            unless row[4].nil?
              row[4].strip!
            end

            category.sequence = row[3]
            category.category_comment = row[4]


            if category.save
              fl = 1
            else
              fl = 2
            end
          end
        end
      end
    end

    if fl == 2
      str = "Error"
    else
      if fl == 1
        str ="All categories has added successfully"
      end
    end
    return str

  end

  def del_file
    File.delete(params[:file])
    redirect_to :action => 'upload'
  end

#********************************Company*************************
   def del_file
    File.delete(params[:file])
    redirect_to :action => 'upload'
  end

  def hash_create(arr)

    hash_sort = {}

    cities = {}
    City.find(:all).each {|c| cities[c.name] = c.id}
    file_first_string = true
    FasterCSV.parse(arr) do |row|
      # Ignore the first string
      if file_first_string
        file_first_string = false
      else
        unless row[1].blank? and row[0].blank?

          if row[1].blank?
            hash_sort[row[0]] = "nil"#row[1]
          else
            row[1].strip!
            unless cities.has_key? row[1]
              hash_sort[row[0]] = row[1]
            end
          end
        end
      end
    end

    arr_sort = hash_sort.to_a.sort {|a,b| a[1]<=>b[1]}
    str = arr_sort.join(",")
    return str

  end

   def save_all

    countries = {}
    Company.find(:all).each {|c| countries[c.name] = c.id}

    cities = {}
    City.find(:all).each {|c| cities[c.name] = c.id}
    temp = {}
    sr = ""
    x1 = 0
    x2 = 0
    fg = 0
    max = params[:max].to_i

    max.times do |i|

      if params[:company][:"city_id_#{i.to_s}"].blank?

        if fg == 0
          x1 = i
          fg = 1
        else
          x2 = i
          unless params[:company][:"city_id_#{x1.to_s}_#{x2.to_s}"].blank?
            x1.upto(x2) do |k|
              temp[k] = params[:company][:"city_id_#{x1.to_s}_#{x2.to_s}"]
            end
            fg = 0
          end
        end

      else

        temp[i] = params[:company][:"city_id_#{i.to_s}"]
        if fg == 1
          x1.upto(x2) do |k|
            temp[k] = params[:company][:"city_id_#{x1.to_s}_#{x2.to_s}"]
          end
          fg = 0
        end
      end
    end

    if fg != 0
      x1.upto(x2) do |k|
        temp[k] =params[:company][:"city_id_#{x1.to_s}_#{x2.to_s}"]
      end
      fg = 0
    end

    temp.each do |q,w|
      puts q,w
    end

    hash_mistake = {}
    hash_short_name = {}
    file_first_string = true
    FasterCSV.foreach(params[:file]) do |row|
      # Ignore the first string
      if file_first_string
        file_first_string = false
      else
        unless row[1].blank? and row[0].blank?

          row[0].strip!
          unless countries.has_key? row[0]

            if row[1].nil?
              unless row[2].nil?
                row[2].strip!
              end

              hash_mistake[row[0]] = "nil"#row[1]
              hash_short_name[row[0]] = row[2]
            else
              row[1].strip!
              row[0].strip!

              unless cities.has_key? row[1]
                hash_mistake[row[0]] = row[1]
                hash_short_name[row[0]] = row[2]
              end
            end
          end
        end
      end
    end

    arr_sort = hash_mistake.to_a.sort {|a,b| a[1]<=>b[1]}
    h = {}
    a1 = 0
    arr_sort.each do |i,w|
      h[a1] = i
      a1 = a1+1
    end

    kol = 0
    fl = "All countries has added successfully"
    arr1 = ""
    #Save
    open(params[:file],"r+") do  |f|
      arr1 = f.read
    end

    file_first_string = true
    FasterCSV.parse(arr1) do |row|
      # Ignore the first string
      if file_first_string
        file_first_string = false
      else
        countries = {}
        Company.find(:all).each {|c| countries[c.name] = c.id}

        unless row[1].blank? and row[0].blank? and row[2].blank?

          row[0].strip!
          puts row[0]
          unless countries.has_key? row[0]

            if row[1].blank?
              n = h.index(row[0])
              cont = temp[n]
              row[1] = cont
            else
              row[1].strip!
              unless cities.has_key? row[1]
                n = h.index(row[0])
                cont = temp[n]
                row[1] = cont
              end
            end

            unless row[2].nil?
              row[2].strip!
            end

            country = Company.new
            country.name = row[0]
            country.shortname = row[2]
            if cont.blank?
              country.city_id = cities[row[1]]
            else
              country.city_id = row[1]
            end

            country.company_comment = row[3]
            unless row[4].nil?
              k = row[4].gsub(/["^`"' ]/,'')
              k.strip!
              k = k.gsub(/[,]/,'.')
              row[4] = k.to_f.round()
            end


            country.acreage = row[4]

            unless row[5].nil?
              k = row[5].gsub(/["^`"' ]/,'')
              k.strip!
              k = k.gsub(/[,]/,'.')
              row[5] = k.to_f.round()
            end

            country.yearly_production = row[5]


            if country.save
              kol = kol + 1
            else
              fl = "Error"
            end
          end
        end
      end
    end

    if kol == 0
      fl = "No countries for add into the database"
    end
    flash[:notice] =  fl
    File.delete(params[:file])
    redirect_to :action => 'list'
  end

  def check(arr)

    cities = {}
    City.find(:all).each {|c| cities[c.name] = c.id}

    countries = {}
    Company.find(:all).each {|c| countries[c.name] = c.id}
    err = ''

    #Find a mistakes
    file_first_string = true
    FasterCSV.parse(arr) do |row|
      # Ignore the first string
      if file_first_string
        file_first_string = false
      else
        unless row[1].blank? and row[0].blank?

          unless countries.has_key? row[0]

            if row[1].blank?
              err << "The city not define for the country " + row[0] + '<br>'
            else
              row[1].strip!
              unless cities.has_key? row[1]
                err << "The city " + row[1] + " not found in the database. Please set a new city for country " + row[0] + '<br>'
              end
            end
          end
        end
      end
    end

    unless err.blank?
      name = rand(100000)
      tmpFile = Tempfile.new(name.to_s)
      tmpFile.write(arr)
      tmpFile.close(true)
      path = tmpFile.path
    #arr = Iconv.new( 'utf-8//IGNORE','utf-8').iconv(arr)
      f = File.new(path,"w")

      f.write(arr)
      f.close

      str = hash_create(arr)
      redirect_to :action => 'result',  :temp_hash => str,:tmp_file => path

      return false

    end

  end


  def upload_file

    flag = 0
    arr = ""
    k = params[:file]
    if k.blank?
      flash[:error] = "Please, select the CSV file to upload "
      action = 'upload'
    else
      k.each do |aa|
        arr << aa
      end

      begin
        FasterCSV.parse(arr) do |row|
          unless row[0]==nil and row[1]==nil and row[2]==nil
            if row[0]==nil
              flash[:error] = "This file not correct. Select another file "
              action = 'upload'
              flag = 1
            end
          end
        end
      rescue => error
        flash[:error] = error #"This file not correct. Select another file "
        action = 'upload'
        flag = 1
      end

      if flag == 0

        cities = {}
        City.find(:all).each {|c| cities[c.name] = c.id}
        countries = {}
        Company.find(:all).each {|c| countries[c.name] = c.id}

        exist = 0
        file_first_string = true
        FasterCSV.parse(arr) do |row|
          # Ignore the first string
          if file_first_string
            file_first_string = false
          else
            unless row[1].blank? and row[0].blank?

              row[0].strip!
              unless  row[1].nil?
                row[1].strip!
              end

              unless countries.has_key? row[0]
                exist = 1
              end
            end
          end
        end

        if exist == 1

          if  check(arr) == false
            return
          end

          str = save(arr)

        else
          str ="All countries exists in the database"
        end

        flash[:notice] = str
        action = "list"
      end
    end
    redirect_to :action => action

  end

  def save(arr)
    cities = {}
    City.find(:all).each {|c| cities[c.name] = c.id}

    countries = {}
    Company.find(:all).each {|c| countries[c.name] = c.id}

    fl = 0
    file_first_string = true

    FasterCSV.parse(arr) do |row|
      # Ignore the first string
      if file_first_string
        file_first_string = false
      else
        countries = {}
        Company.find(:all).each {|c| countries[c.name] = c.id}
        unless row[1].blank? and row[0].blank?

          row[0].strip!
          row[1].strip!
          unless row[2].nil?
            row[2].strip!
          end

          country = Company.new
          country.name = row[0]
          country.shortname = row[2]
          country.city_id = cities[row[1]]
          country.company_comment = row[3]
          unless row[4].nil?
              k = row[4].gsub(/["^`"' ]/,'')
              k.strip!
              k = k.gsub(/[,]/,'.')
              row[4] = k.to_f.round()
            end

          country.acreage = row[4]
          unless row[5].nil?
              k = row[5].gsub(/["^`"' ]/,'')
              k.strip!
              k = k.gsub(/[,]/,'.')
              row[5] = k.to_f.round()
            end

          country.yearly_production = row[5]

          unless countries.has_key? row[0]

            if country.save
              fl = 1
            else
              fl = 2
            end
          end
        end
      end
    end

    if fl == 2
      str = "Error"
    else
      if fl == 1
        str ="All countries has added successfully"
      end
    end

    return str

  end


  #********************Merchandise***************
   def upload_file

    file_error = false
    arr = ""
    file_content = params[:file]
    # Check file contents for blank
    if file_content.blank?
      flash[:error] = "Please, select the CSV file to upload "
      action = 'upload'
    else
      #Copy contain of the file to string arr
       file_content.each do |aa|
         arr << aa
       end
       # Is contains of the file correct?
       begin
         FasterCSV.parse(arr) do |row|
           unless row[0]==nil and row[1]==nil and row[2]==nil
             if row[0]==nil
               flash[:error] = "Error, the first row equal nil. This file not correct. Select another file "
               action = 'upload'
               file_error = true
             end
           end
         end
       rescue => error
         flash[:error] = error
         action = 'upload'
         file_error = true
       end

       if not file_error

         categories = {}
         Category.find(:all).each {|c| categories[c.name] = c.id}
          merchandise = {}
         Merchandise.find(:all).each {|c| merchandise[c.name] = c.id}
#         actors = {}
#         AddressByDate.find(:all).each {|c| actors[c.name] = c.actor_id}
#         merchandise_names = {}
#
#         MerchandiseName.find(:all).each {|c|
#         merchandise_names[c.name] = c.id}

         new_data_exist = false
         file_first_string = true
         # Check for repeated data in the file
         FasterCSV.parse(arr) do |row|
           #Ignore the first string
           if file_first_string
             file_first_string = false
           else

             unless row[1].blank? and row[0].blank? and row[2].blank?

               row[0].strip!
               unless  row[1].nil?
                 row[1].strip!
               end
               unless  row[2].nil?
                 row[2].strip!
               end


#           unless categories.has_key? row[0]
#             unless brand.has_key? row[1]
               unless merchandise.has_key? row[2]
                 new_data_exist = true
               end

             end
           end
         end
        # If new data exist then check for error
         if new_data_exist
#           unless check(arr)
#             return
#           end
           str = save(arr)

         else
           str ="All merchandises exists in the database"
         end

         flash[:notice] = str
         action = "list"
       end
    end
    redirect_to :action => action

  end


  def check(arr)

    categories = {}
    Category.find(:all).each {|c| categories[c.name] = c.id}
    merchandise = {}
    Merchandise.find(:all).each {|c| merchandise[c.name] = c.id}
    string_error = ''

    #Find a mistakes
    file_first_string = true
    FasterCSV.parse(arr) do |row|
      if file_first_string
        file_first_string = false
      else

        unless row[1].blank? and row[0].blank? and row[2].blank?
          unless row[1].nil?
            row[1].strip!
          end
           unless row[0].nil?
            row[0].strip!
          end
            unless row[2].nil?
            row[2].strip!
          end

          unless merchandises.has_key? row[2]
            unless categories.has_key? row[0]
              string_error << "The category not define for the merchandise " + row[0] + '<br>'
            end
          end
        end
      end
    end
    # If mistakes are exists
    unless string_error.blank?

      # Create new temp file
      file_name = rand(100000)
      tmpFile = Tempfile.new(file_name.to_s)
      tmpFile.close(true)
      path = tmpFile.path
      f = File.new(path,"w")
      f.write(arr)
      f.close
    # Create a string for send to the page "result"
      str = hash_create(arr)
      #create_combo(str,path)

      return false
    end

  end

  #  def hash_create(arr)
#
#    hash_sort = {}
#    merchandises = {}
#    MerchandiseName.find(:all).each {|c| merchandises[c.name] = c.id}
#
#    categories = {}
#    Category.find(:all).each {|c| categories[c.name] = c.id}
#    file_first_string = true
#    FasterCSV.parse(arr) do |row|
#      #Ignore the first string
#      if file_first_string
#        file_first_string = false
#      else
#        unless row[1].blank? and row[0].blank?
#          unless merchandises.has_key? row[0]
#            if row[1].blank?
#              hash_sort[row[0]] = "nil"#row[1]
#            else
#              row[1].strip!
#              unless categories.has_key? row[1]
#                hash_sort[row[0]] = row[1]
#              end
#            end
#          end
#        end
#      end
#    end
#    # Hash => array
#    # Sort array by country
#    arr_sort =hash_sort.to_a.sort {|a,b| a[1]<=>b[1]}
#    # Array => string with comma separator
#    str = arr_sort.join(",")
#    return str
#
#  end

  def del_file
    File.delete(params[:file])
    redirect_to :action => 'upload'
  end

#  def create_combo(temp_hash,tmp_file)
#
#    categories = {}
#    Category.find(:all).each {|c| categories[c.name] = c.id}
#
#    countries = {}
#    Company.find(:all).each {|c| countries[c.name] = c.id}
#
#    str = temp_hash
#    data = str.split(",")
#
#    category_array = Array.new
#    list_merchandise_array = Array.new
#    name_combo_array = Array.new
#
#    unless tmp_file.blank?
#      count = (data.length)/2
#      a = 0
#      first_time = true
#      mem = 0
#      listN = ""
#      listWineries = ""
#      con = ""
#      k = 0
#      t = 0
#      number_combo = 0
#      count.times do |i|
#        data[i*2].strip!
#
#        unless categories.has_key? data[i*2]
#          if data[i*2+1] == "nil"
#            if  not first_time  and mem == 1 and k > 1 and t == 0
#              listN << "_" + (a-1).to_s
#              #<%= "The country " + con +  " not found in the database. Please select a new country for category " + listCategories %>
#              #<p><label for="category_country_id"> <%= 'Country' %> </label><br/>
#              #<%= select 'category', "country_id" + listN, Company.for_select %></p>
#              category_array[number_combo] = con
#              list_merchandise_array[number_combo] = listWineries
#              name_combo_array[number_combo] = "country_id" + listN
#              number_combo = number_combo + 1
#              first_time = true
#              mem = 0
#              t = 1
#            end
#
#            #  <%= "The country not define for the category " + data[i*2] +  " .Please select a country" %>
#            # <p><label for="category_country_id"> <%= 'Country' %> </label><br/>
#            #  <%= select 'category', "country_id_" + a.to_s, Company.for_select %></p>
#            category_array[number_combo] = 'nil'
#            list_merchandise_array[number_combo] = data[i*2]
#            name_combo_array[number_combo] = "country_id_" + a.to_s
#            number_combo = number_combo + 1
#          else
#            if k == 0
#              str = data[i*2 + 1]
#              con = data[i*2]
#              listN << "_" + a.to_s
#            end
#
#            if data[i*2 + 1] == str
#
#              if first_time
#                listWineries << " " + data[i*2]
#                con = str
#                first_time = false
#                k = k + 1
#                t = 0
#                mem = 1
#              else
#                listWineries << " " + data[i*2]
#                con = str
#                k = k + 1
#                mem = 1
#                t = 0
#              end
#
#            else
#
#              if not first_time and mem == 1 and k > 1 and t == 0
#                listN << "_" + (a-1).to_s
#              end
#
#              if  mem == 1 or k < 1
#                # <%= "The country " + con +  " not found in the database. Please select a new country for category " + listCategories %>
#                #<p><label for="category_country_id"> <%= 'Country' %> </label><br/>
#                #<%= select 'category', "country_id" + listN, Company.for_select %></p>
#                category_array[number_combo] = con
#                list_merchandise_array[number_combo] = listWineries
#                name_combo_array[number_combo] = "country_id" + listN
#                number_combo = number_combo + 1
#              end
#
#              first_time = true
#              listWineries = " " + data[i*2]
#              listN = "_" + (a).to_s
#              str = data[i*2 + 1]
#              con = str
#              mem = 1
#              k = k + 1
#              t = 1
#            end
#          end
#          a = a + 1
#        end
#      end
#
#      if  not first_time or mem == 1
#        if  t == 0  and k > 1
#          listN << "_" + (k-1).to_s
#        end
#
#        # <%= "The country " + con +  " not found in the database. Please select a new country for category " + listCategories %>
#        #<p><label for="category_country_id"> <%= 'Country' %> </label><br/>
#        #<%= select 'category', "country_id" + listN, Company.for_select %></p>
#        category_array[number_combo] = con
#        list_merchandise_array[number_combo] = listWineries
#        name_combo_array[number_combo] = "country_id" + listN
#      end
#    end
#
#     # Array => string with comma separator
#    category_string = category_array.join(",")
#    list_merchandise_string = list_merchandise_array.join(",")
#    name_combo_string = name_combo_array.join(",")
#    redirect_to :action => 'result',  :country_array => category_string,:list_categories_array => list_merchandise_string,
#    :name_combo_array => name_combo_string, :tmp_file => tmp_file, :max => count
#
#  end

  def save(arr)

    categories = {}
    Category.find(:all).each {|c| categories[c.name] = c.id}

    merchandises = {}
    Merchandise.find(:all).each {|c| merchandises[c.name] = c.id}

    brand = {}
    Brand.find(:all).each {|c| brand[c.name] = c.id}


    fl = 0
    file_first_string = true
    max = nil
    FasterCSV.parse(arr) do |row|
      # Ignore the first string
      if file_first_string
        file_first_string = false
      else
        merchandises = {}
        Merchandise.find(:all).each {|c| merchandises[c.name] = c.id}

        unless row[1].blank? and row[0].blank? and row[2].blank?
          unless categories.has_key? row[0] and brand.has_key? row[1] and merchandises.has_key? row[2]
            row[0].strip!
            row[1].strip!
            row[2].strip!

            merchandise = Merchandise.new
            merchandise.category_id = categories[row[0]]
            merchandise.brand_id = brand[row[1]]


              row[2].strip!
              merchandise.name = row[2]

            unless row[3].nil?
              row[3].strip!
              merchandise.description = row[3]
            end
#            unless row[4].nil?
#              row[4].strip!
#              merchandise.grapevariety = row[4]
#            end
#

#            unless row[5].nil?
#              row[5].strip!
#              merchandise.terroir = row[5]
#            end
#            unless row[6].nil?
#              row[6].strip!
#              merchandise.custom_name = row[6]
#            end
#            unless row[7].nil?
#              row[7].strip!
#              merchandise.tel = row[7]
#            end
#            unless row[8].nil?
#              row[8].strip!
#              merchandise.fax = row[8]
#            end
#            unless row[9].nil?
#              row[9].strip!
#              merchandise.email = row[9]
#            end
#            unless row[10].nil?
#              row[10].strip!
#              merchandise.url = row[10]
#            end

            if merchandise.save
              fl = 1

              # Save into the table MerchandiseColumnDesc
              param_amount = MerchandiseColumnName.find(:all, :conditions => ["category_id=?",categories[row[0]]]).length
              p "param_amount=" + param_amount.to_s
              0.upto(param_amount-1) do |i|
                value = MerchandiseColumnDesc.new

                unless row[i+4].nil?
                  row[i+4].strip!
                  value.column_value = row[i+4]
                end
                unless row[i+4].nil?
                  row[i+4].strip!
                  value.merchan_id = merchandise.id
                end

                value.save
              end
              p "foto="+ ((row.length-(4+param_amount))/2).to_s
              # Save into the table Picture
              0.upto((row.length-(4+param_amount))/2) do |i|
                unless row[i*2+(3+param_amount) + 1].nil?
                  row[i*2+(3+param_amount) + 1].strip!
                  puts row[i*2+(3+param_amount) + 1]
                  title = row[i*2+(4+param_amount) + 1]
                  ImageOwner::upload_pictures merchandise, row[i*2+(3+param_amount) + 1], title
                end

              end
            else
              fl = 2
            end
          end
        end
      end
    end

    if fl == 2
      str = "Error"
    else
      if fl == 1
        str ="All merchandises has added successfully"
      end
    end
    return str

  end

end