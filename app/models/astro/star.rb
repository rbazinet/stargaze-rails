module Astro
  class Star < Astro::AstroObject
    set_table_name 'astro_star'

    belongs_to :constellation, :class_name => "Astro::Constellation"
  end
end