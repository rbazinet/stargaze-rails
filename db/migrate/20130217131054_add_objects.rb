class AddObjects < ActiveRecord::Migration
  def up
    create_table :astro_constellation do |t|
      t.string :name, :null => false
      t.string :abb1
      t.string :abb2
      t.string :genitive
      t.string :origin
      t.string :meaning
    end

    create_table :astro_messier do |t|
      t.integer :messier_number, :null=>false
      t.integer :ngc_number
      t.string :common_name
      t.string :object_type
      t.float :distance_kly
      t.integer :constellation_id, :null=>false
      t.float :apparent_magnitude
    end

    create_table :astro_ngc do |t|
      t.integer :ngc_number, :null=>false
      t.string :names
      t.string :object_type
      t.integer :constellation_id, :null=>false
      t.string :right_ascension
      t.string :declination
      t.float :apparent_magnitude
    end

    create_table :astro_star do |t|
      t.string :name
      t.integer :constellation_id, :null=>false
      t.string :right_ascension
      t.string :declination
      t.float :apparent_magnitude
      t.string :stellar_class
      t.text :info
    end

    create_table :astro_solar do |t|
      t.string :name, :null=>false
      t.integer :position
      t.integer :size
      t.float :size_earth
      t.integer :mass
      t.float :mass_earth
      t.integer :distance
      t.float :distance_earth
      t.float :orbital_period
      t.string :trading_period
      t.integer :moons
      t.string :solar_type
      t.text :info
    end

  end

  def down
    drop_table :astro_constellation
    drop_table :astro_messier
    drop_table :astro_ngc 
    drop_table :astro_star
    drop_table :astro_solar
  end
end
