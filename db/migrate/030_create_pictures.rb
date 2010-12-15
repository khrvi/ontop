class CreatePictures < ActiveRecord::Migration
  def self.up
    create_table :pictures do |t|
      t.column :title,         :string
      t.column :content_type,  :string
      t.column :data,          :binary#, :limit => 5.megabyte
      t.column :icon_data,     :binary#, :limit => 2.megabyte
    end
  end

  def self.down
    drop_table :pictures
  end
end
