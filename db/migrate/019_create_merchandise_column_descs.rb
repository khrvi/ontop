class CreateMerchandiseColumnDescs < ActiveRecord::Migration
  def self.up
    create_table :merchandise_column_descs do |t|
      t.column :column_value,  :text
      t.column :merchan_id,    :integer
      t.column :unit_of,       :string
      t.column :validated,     :boolean
    end
  end

  def self.down
    drop_table :merchandise_column_descs
  end
end
