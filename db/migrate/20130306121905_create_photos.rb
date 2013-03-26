class CreatePhotos < ActiveRecord::Migration
  def up
    create_table :user_photo do |t|  
      t.integer :user_id, :null=>false
      t.integer :observation_id, :null=>false
      t.string :name
      t.string :description
      t.timestamps
    end

    add_attachment :photos, :payload
  end

  def down
    remove_attachment :photos, :payload
    drop_table :user_photo
  end
end
