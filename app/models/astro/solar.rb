module Astro
  class Solar < Astro::AstroObject
    set_table_name 'astro_solar'
    
    validates :name, :position, :size, :size_earth, :mass, :mass_earth, :distance, :distance_earth, :orbital_period, :trading_period, :moons, :type
    validates :name, :uniqueness=>true
    validates :position, :size, :size_earth, :mass, :mass_earth, :distance, :distance_earth, :orbital_period, :trading_period, :moons, :numericality=>true
  end
end
