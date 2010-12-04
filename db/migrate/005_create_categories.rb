class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.column :parent_category_id,  :integer
      t.column :name,                :string
      t.column :sequence,            :integer
      t.column :category_comment,    :text
      t.column :validated,           :boolean
      t.column :created_by,          :string
      t.column :created_at,          :datetime
      t.column :updated_by,          :string
      t.column :updated_at,          :datetime
    end
  end

  def self.down
    drop_table :categories
  end
end
