module Astro
  class Messier < Astro::AstroObject
    set_table_name 'astro_messier'

    belongs_to :constellation, :class_name => "Astro::Constellation"
  end
end