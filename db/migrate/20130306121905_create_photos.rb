class CreatePhotos < ActiveRecord::Migration
  def up
    create_table :user_photo do |t|  
      t.integer :observation_id
      t.timestamps
    end

    add_attachment :user_photo, :payload
  end

  def down
    remove_attachment :photos, :payload
    drop_table :user_photo
  end
end
