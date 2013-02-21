module Astro
  class Constellation < Astro::AstroObject
    set_table_name 'astro_constellation'

    has_many :stars, :class_name => "Astro::Star"
    has_many :messiers, :class_name => "Astro::Messier"
    has_many :ngcs, :class_name => "Astro::Ngc"

    validate :name, :uniqueness=>true
  end
end