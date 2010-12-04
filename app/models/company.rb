class Company < ActiveRecord::Base
  has_many :caches
  has_many :licences
  belongs_to :city
  belongs_to :actor
  has_many :company_categories
  has_and_belongs_to_many :categories
  has_many :albums, :as => :owner
  has_many :custom_company_name
  has_many :price_by_dates
  has_many :address_by_dates
  has_many :conversion_rates
  wnw_ferret 'name'
     
  validates_presence_of :name,:message => "Значения поля 'Название' не должно быть пустыми"
  validates_exclusion_of :name,:message => "Значения поля 'Название' не должно содержать лишних знаков", :in => %w{ 1 2 3 4 5 6 7 8 9 0 < > + = * # @ ! ~}
  validates_presence_of :tel,:message => "Значения поля 'Телефон' не должно быть пустыми"
  validates_numericality_of :tel,:message => "Значения поля 'Телефон' должено содержать только цифры", :only_integer => true
  validates_numericality_of :fax,:message => "Значения поля 'Факс' должено содержать только цифры", :only_integer => true
  validate
    
  def self.for_select
    result = []
    all = Company.find(:all).sort {|x, y| x.name <=> y.name}
    all.each { |c| result << [[c.name, c.id]] }
    result
  end
  
  protected
  def validate
    if email.nil? || email.empty? || email.index("@").nil?
      errors.add(:email, "Укажите правельный email адресс")
    end
  end
end
