# encoding: UTF-8
class Admin::StatisticsController < Admin::AbstractAdminController

  def pie_links
        data = links = city_c = []
        city = City.find(:all)
        city.each do |t|
          temp1 = Company.find_all_by_city_id(t.id).length
          city_c << t.name
          data << temp1
         links << "/admin/company"
        end

        g = Graph.new
        g.pie(60, '#505050', '#000000')
        g.pie_values(data, city_c, links)
        g.pie_slice_colors(%w(#d01fc3 #356aa0 #c79810 #a010c3 #7999a0 #810910))
        g.set_tool_tip("#val#%")
        g.title("Города и Компании", '{font-size:18px; color: #d01f3c}' )
        render :text => g.render
  end
  
  
  def index
    @menu = [:admin, :statistics, :index]
    @count_users = User.count
    @graph = open_flash_chart_object(500,400, 'statistics/pie_links', false, '/')
    @count_users_active = StatsLogin.find(:all, :conditions => ['login_at >= ?', Time.now - 1.month]).collect { |sl|
      sl.login
    }.uniq.length
    @count_brands = Brand.count
    @count_merchandises = Merchandise.count
    @count_categories = Category.count
    @count_companies = Company.count
    @last_logins = StatsLogin.find(:all, :order => 'login_at DESC', :limit => 5)
    #temp1 = Company.find_by_city_id(5).length
  end
  
  def login
    @menu = [:admin, :statistics, :login]
    @stats_logins = StatsLogin.find(:all)
  end
  
    protected
  def init_menu
    @menu = [:admin]
  end
end
