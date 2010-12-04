class CreatePictureMerchandises < ActiveRecord::Migration
  def self.up
    create_table :picture_merchandises, :id => false do |t|
      t.column :picture_id, :integer
      t.column :merchandise_id,  :integer
    end
  end

  def self.down
    drop_table :picture_merchandises
  end
end
