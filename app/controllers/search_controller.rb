# encoding: UTF-8
class SearchController < ApplicationController

  def update_merch
    @category_id = params[:category_id]
    @array_names = []
    @array_description = []
    Category.find(@category_id).merchandise_column_names.each do |q|
      @array_names <<  q.column_name
      @array_description <<  q.description
    end
    @amount = @array_names.length
    
    render :update do |page|
      #page.hide 'parameters'
      page.visual_effect :fade,'parameters', :duration => 0.2
      page.delay(0.2) do
        page.replace_html 'parameters', :partial => 'param_field', :locals => {:category_id => @category_id} 
      end
      page.delay(0.4) do
        page.visual_effect :appear,'parameters'
      end
    end
  end
  
  def update_result
    amount = params[:amount].to_i
    result = []
    0.upto(amount-1) do |e|
      result[e] = params[:category][:"#{e}"]
    end
    
  # mer = MerchandiseColumnDesc.find_by_id(result[0])
    base = [] 
    mer = nil
    a = 0
    result.each do |i| 
      unless i.nil? or i.empty?
        merchandise_array = []
        mer = MerchandiseColumnDesc.find_by_id(i) 
        MerchandiseColumnDesc.find_all_by_column_value(mer.column_value).each  do |e|
          merchandise_array << e.merchan_id 
        end
       
        if a > 0
          base = base & merchandise_array
        else
          base = base + merchandise_array
          a += 1    
        end
      end
    end

    render :update do |page|
     # page.hide 'results'
      page.visual_effect :fade,'results', :duration => 0.2
      page.delay(0.2) do
        #page.replace_html 'results', :partial => "results"#, :locals => {:mer => mer, :array => base} 
        page.replace_html 'results', :partial => '/search/result_field', :locals => {:mer => mer, :array => base}
      end
      page.delay(0.4) do
        page.visual_effect :appear,'results'
      end
    end
  end
  
  def update_image
#    raise params.inspect
#    pic = Album.find_by_picture_id(params[:picture_id])
    render :update do |page|
      page.hide 'picture'
      page.delay(0.2) do
        page.replace_html 'picture', :partial => '/search/picture', :locals => {:picture_id => params[:picture_id]}
      end
      page.delay(0.4) do
        page.visual_effect :appear,'picture'
      end
    end
  end
  
  def index
    @cities = City.find(:all).sort { |a, b| a.name <=> b.name}
  end
  
  def search
    name       = '(*' + params[:name] + '*) OR (' + params[:name] + '~)'
    
    limit = 20
    merchandises = Merchandise.find_by_contents(name, :limit => limit)
    merchan_ids = {}
    merchandises.each do |w|
      merchan_ids[w.id] = true
    end

    render :partial => 'results_form', :locals => {
           :companies  => Company.find_by_contents(name, :limit => limit),
           :categories    => Category.find_by_contents(name, :limit => limit),
           :merchandises   => merchandises,
           :brands     => Brand.find_by_contents(name, :limit => limit),
    }
  end
  
  def show_company
    @company = Company.find(params[:id])
  end
  
  def show_category
    @category = Category.find(params[:id])
  end
  
  def show_merchandise
    @merchandise = Merchandise.find(params[:id])
    session[:merchan_id] = params[:id]
    @graph = open_flash_chart_object(300,240, '/search/extra', false, '/')
  end

  def search_merchandise
    @menu << :search_merchandise
  end
  
  def extra
    # comp_id = Company.find_by_actor_id(User.find(session[:user].to_i).actor_id).id
    #Line weigth and color 
    data_1 = Line.new(2, '#9933CC')
    #Title line + font size
    data_1.key('Максимальная', 10)

    #    data_2 = LineHollow.new(2,5,'#CC3399')
    #    data_2.key("Downloads",10)
    data_3 = LineHollow.new(2,4,'#80a033')
    data_3.key("Минимальная", 10)
    prices = []
    prices = PriceByDate.find(:all, :conditions => ["merchan_id=?", merchan_id])
    (0..12).each do |i|
      data_1.add_data_tip(Price.find_by_id(prices[i].price_id).amount, "(Extra: #{i})")
      # data_2.add_data_tip(rand(5) + 8,  "(Extra: #{i})")
      data_3.add_data_tip(rand(6) + 1,  "(Extra: #{i})")
    end

    g = Graph.new
    g.title("Изменение цены за месяц", "{font-size: 16px; color: #736AFF}")
    g.data_sets << data_1
    # g.data_sets << data_2
    g.data_sets << data_3

    g.set_tool_tip('#x_label# [#val#]<br>#tip#')
    g.set_x_labels(%w(Jan Feb Mar Apr May Jun Jul Aug Sept Oct Nov Dec))
    g.set_x_label_style(10, '#000000', 0, 2)
    
    #Max means for vertical line
    g.set_y_max(500)
    #Quantity of digree for vertical line
    g.set_y_label_steps(5)
    g.set_y_legend("Стоимость", 12, "#736AFF")

    render :text => g.render
  end
  
  protected
  def init_menu
    @menu = [:search]
  end
end
