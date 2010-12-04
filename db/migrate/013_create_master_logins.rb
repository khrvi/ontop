class CreateMasterLogins < ActiveRecord::Migration
  def self.up
    create_table :master_logins do |t|
      t.column :login, :string
      t.column :password, :string
    end
  end

  def self.down
    drop_table :master_logins
  end
end
