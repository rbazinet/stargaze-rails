module Astro
  class Ngc < Astro::AstroObject
    set_table_name 'astro_ngc'

    belongs_to :constellation, :class_name => "Astro::Constellation"
  end
end