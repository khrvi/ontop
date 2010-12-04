class CreatePictureCities < ActiveRecord::Migration
  def self.up
    create_table :picture_cities, :id => false do |t|
      t.column :picture_id, :integer
      t.column :city_id,    :integer
      t.column :validated,  :boolean
    end
  end

  def self.down
    drop_table :picture_cities
  end
end
