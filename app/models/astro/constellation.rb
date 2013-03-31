module Astro
  class Constellation < ActiveRecord::Base
    set_table_name 'astro_constellation'

    has_many :stars, :class_name => "Astro::Star"
    has_many :messiers, :class_name => "Astro::Messier"
    has_many :ngcs, :class_name => "Astro::Ngc"

    has_many :observations, :as=>:observable
    has_many :photos, :through=>:observations

    validate :name, :uniqueness=>true
  end
end