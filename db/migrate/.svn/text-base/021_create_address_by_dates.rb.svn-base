class CreateAddressByDates < ActiveRecord::Migration
  def self.up
    create_table :address_by_dates do |t|
      t.column :company_id,       :integer
      t.column :name,           :string
      t.column :address_line_1, :string
      t.column :address_line_2, :string
      t.column :address_line_3, :string
      t.column :address_line_4, :string
      t.column :zip_code,       :string
      t.column :district_id,    :integer
      t.column :created_by,     :string
      t.column :created_at,     :datetime
      t.column :updated_by,     :string
      t.column :updated_at,     :datetime
    end
  end

  def self.down
    drop_table :address_by_dates
  end
end
