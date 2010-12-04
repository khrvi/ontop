class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.column :actor_id,                  :integer
      t.column :login,                     :string
      t.column :email,                     :string
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_by,                :string
      t.column :created_at,                :datetime
      t.column :updated_by,                :string
      t.column :updated_at,                :datetime
      t.column :activation_code,           :string, :limit => 40
      t.column :activated_at,              :datetime
    end
  end

  def self.down
    drop_table "users"
  end
end
