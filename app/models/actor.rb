class Actor < ActiveRecord::Base
  validates_presence_of :actor_type
  
  has_one  :user
  has_one  :person
  has_one  :company
  has_many :custom_company_names

end
