class MerchandiseColumnDesc < ActiveRecord::Base
  belongs_to :merchandise
#  wnw_ferret 'column_value'

  def self.for_select(cat_id, col)
    value = []
    arr_id = []
    result = []
    amount = MerchandiseColumnName.find_all_by_category_id(cat_id).length
    array_merch = []
    Merchandise.find_all_by_category_id(cat_id).each {|t| array_merch << t.id }
    all = MerchandiseColumnDesc.find_all_by_merchan_id(array_merch)#.sort {|x, y| x.column_value <=> y.column_value}
    count = 0
    all.each do |c|
      count = 0 if count == amount
      if count == col
        if value.index(c.column_value).nil? 
          value << c.column_value
          arr_id << c.id
        end  
      end
      count += 1
    end
    0.upto(value.length-1) do  |c|
      result += [[value[c], arr_id[c]]]
    end
    result
  end
end
