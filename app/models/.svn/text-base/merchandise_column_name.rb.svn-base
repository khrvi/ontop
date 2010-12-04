class MerchandiseColumnName < ActiveRecord::Base
  belongs_to :category
  wnw_ferret 'name'

  def self.for_select
    result = []
    temp = {}
    MerchandiseColumnName.find(:all).each do |a|
      name = a.category.name
      unless temp.has_key? name
        temp[name] =  a.category_id
        result << [[name ,a.category_id]]
      end
    end
    result.uniq!  
  end
end
