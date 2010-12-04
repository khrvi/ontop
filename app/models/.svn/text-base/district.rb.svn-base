class District < ActiveRecord::Base
  belongs_to :city
  has_many   :address_by_dates
  wnw_ferret 'name'

  def self.for_select
    result = []
    all = District.find(:all).sort {|x, y| x.name <=> y.name}
    all.each { |c| result << [[c.name, c.id]] }
    result
  end

  def self.select(city_id)
    result = []
    all = District.find(:all, :conditions => ["city_id=?",city_id]).sort {|x, y| x.name <=> y.name}
    all.each { |c| result << [[c.name, c.id]] }
    result
  end
end
