class CreatePriceByDates < ActiveRecord::Migration
  def self.up
    create_table :price_by_dates do |t|
      t.column :company_id,     :integer
      t.column :merchan_id,     :integer
      t.column :price_id,       :integer
      t.column :price_type,     :string
      t.column :price_date,     :datetime
      t.column :quantity,       :integer
      t.column :created_by,     :string
      t.column :created_at,     :datetime
      t.column :updated_by,     :string
      t.column :updated_at,     :datetime
    end
  end

  def self.down
    drop_table :price_by_dates
  end
end
