class Brand < ActiveRecord::Base
  include ImageOwner
  
  has_many :merchandises
  has_many :albums, :as => :owner, :dependent => :destroy
  
#  wnw_ferret 'name'
     
  def self.for_select
    result = []
    all = Brand.find(:all).sort {|x, y| x.name <=> y.name}
    all.each { |c| result << [[c.name, c.id]] }
    result
  end
end
