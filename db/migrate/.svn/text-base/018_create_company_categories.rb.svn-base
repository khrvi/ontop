class CreateCompanyCategories < ActiveRecord::Migration
  def self.up
    create_table :company_categories do |t|
      t.column :company_id,       :integer
      t.column :category_id,      :integer
      t.column :created_by,       :string
      t.column :created_at,       :datetime
      t.column :updated_by,       :string
      t.column :updated_at,       :datetime
    end
  end

  def self.down
    drop_table :company_categories
  end
end
