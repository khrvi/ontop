class CreatePolymorphicTableForPictures < ActiveRecord::Migration
  def self.up
    create_table :albums do |t|
      t.column :picture_id, :integer
      t.references :owner, :polymorphic => true
    end
    add_column :pictures, :validated, :boolean, :default => false
  end

  def self.down
    drop_table :albums
    remove_column :pictures, :validated
  end
end
