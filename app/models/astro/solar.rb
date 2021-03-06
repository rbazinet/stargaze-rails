module Astro
  class Solar < ActiveRecord::Base
    set_table_name 'astro_solar'

    acts_as_commentable
    acts_as_votable
    
    has_many :observations, :as=>:observable, :class_name=>"Addable::Observation"
    has_many :photos, :through=>:observations

    validates :name, :position, :size, :size_earth, :mass, :mass_earth, :distance, :distance_earth, :orbital_period, :trading_period, :moons, :solar_type, :presence=>true
    validates :name, :uniqueness=>true
    validates :position, :size, :size_earth, :mass, :mass_earth, :distance, :distance_earth, :orbital_period, :moons, :numericality=>true

    def get_name
      return self.name
    end
  end
end
