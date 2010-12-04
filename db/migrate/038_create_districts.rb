class CreateDistricts < ActiveRecord::Migration
  def self.up
    create_table :districts do |t|
      t.column :name,         :string
      t.column :city_id,      :integer
      t.column :description,  :text
      t.column :validated,    :boolean
    end
  end

  def self.down
    drop_table :districts
  end
end
