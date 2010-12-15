class City < ActiveRecord::Base
  has_many :albums, :as => :owner
  has_many :districts
  
  # wnw_ferret 'name'
  
  def self.for_select
    result = []
    all = City.find(:all).sort {|x, y| x.name <=> y.name}
    all.each { |c| result << [[c.name, c.id]] }
    result
  end
end
