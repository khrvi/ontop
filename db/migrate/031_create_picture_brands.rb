class CreatePictureBrands < ActiveRecord::Migration
  def self.up
    create_table :picture_brands, :id => false do |t|
      t.column :picture_id, :integer
      t.column :brand_id,  :integer
    end
  end

  def self.down
    drop_table :picture_brands
  end
end
