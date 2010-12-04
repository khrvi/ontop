class CreateStatsLogins < ActiveRecord::Migration
  def self.up
    create_table :stats_logins do |t|
      t.column :login, :string
      t.column :login_at, :datetime
      t.column :login_type, :string
    end
  end

  def self.down
    drop_table :stats_logins
  end
end
