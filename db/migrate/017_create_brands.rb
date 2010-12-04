class CreateBrands < ActiveRecord::Migration
  def self.up
    create_table :brands do |t|
      t.column :name,        :string
      t.column :description, :text
      t.column :site,        :string
      t.column :validated,   :boolean
      t.column :checked,     :boolean
    end
  end

  def self.down
    drop_table :brands
  end
end
