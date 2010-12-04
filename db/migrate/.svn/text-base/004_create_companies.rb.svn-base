class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.column :actor_id,        :integer
      t.column :name,            :string
      t.column :company_comment, :text
      t.column :custom_name,     :string
      t.column :kind,            :string
      t.column :tel,             :string
      t.column :fax,             :string
      t.column :email,           :string
      t.column :url,             :string
      t.column :checked,         :boolean
      t.column :valid_from,      :date
      t.column :valid_thru,      :date
      t.column :created_by,      :string
      t.column :created_at,      :datetime
      t.column :updated_by,      :string
      t.column :updated_at,      :datetime
    end
  end

  def self.down
    drop_table :companies
  end
end
