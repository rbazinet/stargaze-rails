module Astro
  class Star < ActiveRecord::Base
    set_table_name 'astro_star'

    belongs_to :constellation, :class_name => "Astro::Constellation"

    has_many :observations, :as=>:observable
    has_many :photos, :through=>:observations
  end
end