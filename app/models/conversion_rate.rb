class ConversionRate < ActiveRecord::Base
    belongs_to :company
    belongs_to :currency
end
