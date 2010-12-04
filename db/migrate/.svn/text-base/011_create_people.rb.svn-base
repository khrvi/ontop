class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.column :actor_id,         :integer
      t.column :first_name,       :string
      t.column :last_name,        :string
      t.column :position,         :string
      t.column :phone,            :string
      t.column :mobile,           :string
      t.column :fax,              :string
      t.column :email,            :string
      t.column :birthday,         :date
      t.column :created_by,       :string
      t.column :created_at,       :datetime
      t.column :updated_by,       :string
      t.column :updated_at,       :datetime
    end
  end

  def self.down
    drop_table :people
  end
end
