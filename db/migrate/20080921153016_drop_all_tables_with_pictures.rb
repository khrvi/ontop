class DropAllTablesWithPictures < ActiveRecord::Migration
  def self.up
    drop_table :picture_brands
    drop_table :picture_merchandises
    drop_table :picture_companies
    drop_table :picture_people
    drop_table :picture_cities
    drop_table :picture_categories
  end

  def self.down
    create_table :picture_brands, :id => false do |t|
      t.column :picture_id, :integer
      t.column :brand_id,  :integer
    end
    create_table :picture_merchandises, :id => false do |t|
      t.column :picture_id, :integer
      t.column :merchandise_id,  :integer
    end
    create_table :picture_companies, :id => false do |t|
      t.column :picture_id, :integer
      t.column :company_id,  :integer
    end
    create_table :picture_people, :id => false do |t|
      t.column :picture_id, :integer
      t.column :person_id,  :integer
    end
    create_table :picture_cities, :id => false do |t|
      t.column :picture_id, :integer
      t.column :city_id,    :integer
    end
    create_table :picture_categories, :id => false do |t|
      t.column :picture_id, :integer
      t.column :category_id,  :integer
    end
  end
end
