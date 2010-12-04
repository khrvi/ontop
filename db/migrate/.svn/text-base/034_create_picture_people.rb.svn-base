class CreatePicturePeople < ActiveRecord::Migration
  def self.up
    create_table :picture_people, :id => false do |t|
      t.column :picture_id, :integer
      t.column :person_id,  :integer
    end
  end

  def self.down
    drop_table :picture_people
  end
end
