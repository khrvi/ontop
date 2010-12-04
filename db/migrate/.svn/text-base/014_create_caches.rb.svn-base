class CreateCaches < ActiveRecord::Migration
  def self.up
    create_table :caches do |t|
      t.column :company_id,       :integer
      t.column :merchan_id, :integer
      t.column :created_by, :string
      t.column :created_at, :datetime
      t.column :updated_by, :string
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :caches
  end
end
