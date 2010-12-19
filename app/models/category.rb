class Category < ActiveRecord::Base
  include ImageOwner
  belongs_to :parent_category, :class_name => 'Category', :foreign_key => 'parent_category_id'
  has_many :categories, :class_name => 'Category', :foreign_key => 'parent_category_id', :order => 'sequence, name'
  has_many :merchandises
  has_many :albums, :as => :owner
  has_many :company_categories
  has_many :merchandise_column_names
  #has_and_belongs_to_many :companies

  #wnw_ferret 'name'

  def full_name separator = ' / '
    s = ''
    begin
      s << self.name + separator
    end while !self.parent_category.nil?
    s << company.name unless company_id.nil?
    s
  end

  def country_name
    company_id ? company.name : '---'
  end

  def self.for_select
    result = []
    temp = {}
    Merchandise.find(:all).each do |a|
      name = a.category.name
      unless temp.has_key? name
        temp[name] = a.category_id
        result << [[name, a.category_id]]
      end
    end
    result.uniq!
    result
  end

  def self.select
    result = []
    all = Category.find(:all).sort {|x, y| x.name <=> y.name}
    all.each { |c| result << [[c.name, c.id]] }
    result
  end

  def self.select_my_category(c)
    result = []
    temp = []
    CompanyCategory.find_all_by_company_id(c).each {|q| temp << q.category_id}
    all = Category.find(temp).sort {|x, y| x.name <=> y.name}
    all.each { |c| result << [[c.name, c.id]] }
    result
  end

  def root?
    self.parent_category_id.nil?
  end

  def has_merchandises?(company)
    !(self.merchandises - company.price_by_dates.map(&:merchandise)).empty?
  end
end
