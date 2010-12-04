class Person < ActiveRecord::Base
  include ImageOwner
  belongs_to :actor
  has_many :albums, :as => :owner
  
  validates_presence_of :first_name,:message => "Значения поля 'Имя' не должно быть пустыми"
  validates_exclusion_of :first_name,:message => "Значения поля 'Имя' не должно содержать лишних знаков", :in => %w{ 1 2 3 4 5 6 7 8 9 0 < > + = * # @ ! ~}
  validates_presence_of :last_name,:message => "Значения поля 'Фамилия' не должно быть пустыми"
  validates_exclusion_of :last_name,:message => "Значения поля 'Фамилия' не должно содержать лишних знаков", :in => %w{ 1 2 3 4 5 6 7 8 9 0 < > + = * # @ ! ~}
  validates_presence_of :position,:message => "Значения поля 'Должность' не должно быть пустыми"
  validates_exclusion_of :position,:message => "Значения поля 'Должность' не должно содержать лишних знаков", :in => %w{ 1 2 3 4 5 6 7 8 9 0 < > + = * # @ ! ~}
  validates_presence_of :birthday,:message => "Значения поля 'Дата рождения' не должно быть пустыми"
  validates_presence_of :phone,:message => "Значения поля 'Телефон' не должно быть пустыми"
  validates_presence_of :mobile,:message => "Значения поля 'Мобильный телефон' не должно быть пустыми"
  validates_numericality_of :phone,:message => "Значения поля 'Телефон' должено содержать только цифры", :only_integer => true
  validates_numericality_of  :mobile,:message => "Значения поля 'Мобильный телефон' должено содержать только цифры", :only_integer => true
  
  def create_or_update
    if actor_id.nil?
      a = Actor.create! :actor_type => 'P'
      self.actor_id = a.id
    end
    super
  end

  def full_name
    s = ''
    s << first_name unless first_name.blank?
    s << ' ' unless first_name.blank? && last_name.blank?
    s << last_name unless last_name.blank?
    s
  end
end
