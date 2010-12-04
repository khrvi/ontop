class CreatePrices < ActiveRecord::Migration
  def self.up
    create_table :prices do |t|
      t.column :currency_id,       :integer
      t.column :amount, :integer
      t.column :created_by, :string
      t.column :created_at, :datetime
      t.column :updated_by, :string
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :prices
  end
end
