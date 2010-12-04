class AddSampleData < ActiveRecord::Migration

  def self.up
    City.transaction do
      minsk = City.create! :name => 'Минск'

      District.create! :name => 'Московский', :city_id => minsk.id
      District.create! :name => 'Фрунзенский', :city_id => minsk.id
      d3 = District.create! :name => 'Центральный', :city_id => minsk.id
      District.create! :name => 'Первомайский', :city_id => minsk.id
      District.create! :name => 'Заводской', :city_id => minsk.id
      District.create! :name => 'Советский', :city_id => minsk.id
      District.create! :name => 'Партизанский', :city_id => minsk.id
      District.create! :name => 'Ленинский', :city_id => minsk.id
      District.create! :name => 'Октябрьский', :city_id => minsk.id

      silverado = Company.create! :name => 'Silverado', :tel => '343423', :fax => '333333', :email => 'ffff@gfgd'#, :actor_id => a.id
      Company.create! :name => 'Shopper.by', :tel => '343423', :fax => '333333', :email => 'ffff@gfgd'
      Company.create! :name => 'Jet', :tel => '343423', :fax => '333333', :email => 'ffff@gfgd'

      AddressByDate.create! :company_id => silverado.id, :district_id => d3.id, :address_line_1 => 'fffffffffffffff'

      item1 = Category.create! :name => 'Компьютерная техника', :sequence => '1'
      item2 = Category.create! :name => 'Мониторы', :parent_category_id => item1.id, :sequence => '1'
      item3 = Category.create! :name => 'Комплектующие', :parent_category_id => item1.id, :sequence => '2'
      item4 = Category.create! :name => 'Видеокарты', :parent_category_id =>  item3.id, :sequence => '3'
      item5 = Category.create! :name => 'Процессоры', :parent_category_id =>  item3.id, :sequence => '4'

      CompanyCategory.create! :company_id => silverado.id, :category_id => item1.id
      categ2 = CompanyCategory.create! :company_id => silverado.id, :category_id => item2.id
      CompanyCategory.create! :company_id => silverado.id, :category_id => item3.id
      CompanyCategory.create! :company_id => silverado.id, :category_id => item4.id
      CompanyCategory.create! :company_id => silverado.id, :category_id => item5.id

      MerchandiseColumnName.create! :category_id => categ2.id, :column_name => "Тип", :description => "Технология производства дисплея"
      MerchandiseColumnName.create! :category_id => categ2.id, :column_name => "Диагональ", :description => "Расстояние в дюймах"
      MerchandiseColumnName.create! :category_id => categ2.id, :column_name => "Зерно", :description => "Размер пиксела в нм"
      MerchandiseColumnName.create! :category_id => categ2.id, :column_name => "Максимальное разрешение", :description => "Максимальное разрешение экрана в пикселах"
      MerchandiseColumnName.create! :category_id => categ2.id, :column_name => "Контрастность", :description => "Соотношение яркости самой светлой точки к самой чёрной"
      MerchandiseColumnName.create! :category_id => categ2.id, :column_name => "Яркость", :description => "Максимальная яркость дисплея"

      Brand.create! :name => 'AMD',
                    :description => 'Компания AMD (NYSE: AMD) ориентируясь на инновации, развитие индустрии и расширение выбора, предлагает наилучшие решения для практических задач пользователей и делает технологию более доступной для всего мира. AMD сфокусированно на том, чтобы соответствовать нуждам ведущих мировых компаний по производству компьютеров, предлагающих беспроводные решения и бытовой электроники и помогать им привносить высокопроизводительные, энергоэффективные и визуально реалистичные решения в жизнь.',
                    :site => 'www.amd.com'

      Brand.create! :name => 'Intel',
                    :description => "Intel pushes the boundaries of innovation so our work can make people's lives more exciting, fulfilling, and manageable. And our work never stops. We never stop looking for the next leap ahead—in technology, education, culture, manufacturing, and social responsibility. And we never stop collectively delivering better solutions with greater benefits for everyone. ",
                    :site => 'www.intel.com'

      lg =Brand.create! :name => 'LG',
                    :description => "LG pushes the boundaries of innovation so our work can make people's lives more exciting, fulfilling, and manageable. And our work never stops. We never stop looking for the next leap ahead—in technology, education, culture, manufacturing, and social responsibility. And we never stop collectively delivering better solutions with greater benefits for everyone. ",
                    :site => 'www.lg.com'

      first = Merchandise.create! :category_id => categ2.id, :brand_id => lg.id, :name => "19BL", :checked => true

      MerchandiseColumnDesc.create! :merchan_id => first.id, :column_value => "LCD",:column_value => "19",:column_value => "0.28",:column_value => "1600x1200",:column_value => "3000:1",:column_value => "300"
      MerchandiseColumnDesc.create! :merchan_id => first.id, :column_value => "19"
      MerchandiseColumnDesc.create! :merchan_id => first.id,  :column_value => "0.28"
      MerchandiseColumnDesc.create! :merchan_id => first.id, :column_value => "1600x1200"
      MerchandiseColumnDesc.create! :merchan_id => first.id, :column_value => "3000:1"
      MerchandiseColumnDesc.create! :merchan_id => first.id, :column_value => "300"

      Cache.create! :merchan_id => first.id, :company_id => silverado.id

      Currency.create! :name => "Беларусский рубль", :designation => "руб."
      Currency.create! :name => "Американский доллар", :designation => "USD"
      Currency.create! :name => "Евро", :designation => "EUR"
      Currency.create! :name => "Российский рубль", :designation => "рос.руб."
    end
  end

  def self.down
  end
  
end
