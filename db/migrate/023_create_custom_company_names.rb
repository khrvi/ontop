class CreateCustomCompanyNames < ActiveRecord::Migration
  def self.up
    create_table :custom_company_names do |t|
      t.column :actor_id, :integer
      t.column :company_id, :integer
      t.column :name, :string
    end
  end

  def self.down
    drop_table :custom_company_names
  end
end
