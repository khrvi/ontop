class CreateCities < ActiveRecord::Migration
  def self.up
    create_table :cities do |t|
      t.column :name,        :string
      t.column :description, :text
      t.column :validated,   :boolean
      t.column :created_by,  :string
      t.column :created_at,  :datetime
      t.column :updated_by,  :string
      t.column :updated_at,  :datetime
    end
  end

  def self.down
    drop_table :cities
  end
end
