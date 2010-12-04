class Currency < ActiveRecord::Base
  has_many :prices
  has_many :conversion_rates
    
  def self.for_select
    result = []
    all = Currency.find(:all).sort {|x, y| x.name <=> y.name}
    all.each { |c| result << [[c.name, c.id]] }
    result
  end
end
