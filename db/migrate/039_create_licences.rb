class CreateLicences < ActiveRecord::Migration
  def self.up
    create_table :licences do |t|
      t.column :name,            :string
      t.column :licence_number,  :string
      t.column :company_id,      :integer
      t.column :who_added,       :string
      t.column :valid_thru,      :datetime
    end
  end

  def self.down
    drop_table :licences
  end
end
