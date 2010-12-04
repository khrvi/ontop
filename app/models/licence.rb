class Licence < ActiveRecord::Base
  belongs_to :company
  #wnw_ferret 'name'
 
  def self.for_select
    result = []
    all = Licence.find(:all).sort {|x, y| x.name <=> y.name}
    all.each { |c| result << [[c.name, c.id]] }
    result
  end
end
