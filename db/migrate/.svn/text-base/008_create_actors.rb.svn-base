class CreateActors < ActiveRecord::Migration
  def self.up
    create_table :actors do |t|
      t.column :actor_type, :string
      t.column :created_by,  :string
      t.column :created_at,  :datetime
      t.column :updated_by,  :string
      t.column :updated_at,  :datetime
    end
  end

  def self.down
    drop_table :actors
  end
end
