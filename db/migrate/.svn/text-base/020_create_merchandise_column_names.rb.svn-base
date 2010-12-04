class CreateMerchandiseColumnNames < ActiveRecord::Migration
  def self.up
    create_table :merchandise_column_names do |t|
      t.column :column_name,  :string
      t.column :category_id,  :integer
      t.column :description,  :text
      t.column :validated,    :boolean
    end
  end

  def self.down
    drop_table :merchandise_column_names
  end
end
