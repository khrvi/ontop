class CreateConversionRates < ActiveRecord::Migration
  def self.up
    create_table :conversion_rates do |t|
      t.column :company_id,          :integer
      t.column :currency_from,       :integer
      t.column :currency_thru,       :integer 
      t.column :rate_from,           :integer
      t.column :rate_thru,           :integer
    end
  end

  def self.down
    drop_table :conversion_rates
  end
end

