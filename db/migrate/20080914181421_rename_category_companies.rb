class RenameCategoryCompanies < ActiveRecord::Migration
  def self.up
    rename_table :company_categories, :categories_companies
  end

  def self.down
    rename_table :categories_companies , :company_categories
  end
end
