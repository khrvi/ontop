class CreatePictureCategories < ActiveRecord::Migration
  def self.up
    create_table :picture_categories, :id => false do |t|
      t.column :picture_id, :integer
      t.column :category_id,  :integer
    end
  end

  def self.down
    drop_table :picture_categories
  end
end
