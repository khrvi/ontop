class AddressByDate < ActiveRecord::Base
  belongs_to :district
  belongs_to :company
   
  validates_presence_of :address_line_1, :message => "Значения поля 'Адрес' не должно быть пустыми"
  validates_presence_of :district_id, :message => "Значения поля 'Город/Район' не должно быть пустыми"
end
