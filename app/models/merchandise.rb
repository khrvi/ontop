# encoding: UTF-8
class Merchandise < ActiveRecord::Base
  include ImageOwner
  
  belongs_to :category
  has_many :caches
  has_many :albums, :as => :owner
  has_many :merchandise_column_descs
  belongs_to :price_by_dates  
  belongs_to :brand
  
#  wnw_ferret 'name'
  attr_accessor :ferret_score
  
  def price
    prices = self.price_by_dates.prices
    if prices.empty?
      'нет цены'
    else
      prices.last.amount
    end  
  end
 
  def full_name
    name + ' / ' + category_name
  end
  
  def name_as_of d = Date.today
    results = MerchandiseName.find(:all, :conditions =>
      ['merchan_id=? and (valid_from is null or (valid_from is not null and valid_from <= ?)) and (valid_thru is null or (valid_thru is not null and valid_thru > ?))', self.id, d, d],
      :order => 'valid_from DESC')
    !results.empty? ? results.first.name : '---'
  end

  def self.list_with_pagination(page, count)
    self.paginate :page => page, :per_page => count, :order => 'brand_id'
  end
end
