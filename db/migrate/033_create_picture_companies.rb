class CreatePictureCompanies < ActiveRecord::Migration
  def self.up
    create_table :picture_companies, :id => false do |t|
      t.column :picture_id, :integer
      t.column :company_id,  :integer
    end
  end

  def self.down
    drop_table :picture_companies
  end
end
