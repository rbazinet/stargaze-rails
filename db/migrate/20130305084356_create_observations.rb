class CreateObservations < ActiveRecord::Migration
  def up
    create_table :user_observation do |t|
      
      t.integer :user_id, :null=>false
      t.string :name, :null => false
      t.string :description
      t.string :eq_used
      t.string :conditions
      t.date :observation_date
      t.belongs_to :observable, polymorphic: true
      t.timestamps
    end
  end

  def down
    drop_table :user_observation
  end
end
