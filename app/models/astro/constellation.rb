module Astro
  class Constellation < ActiveRecord::Base
    set_table_name 'astro_constellation'

    acts_as_commentable
    acts_as_votable

    has_many :stars, :class_name => "Astro::Star"
    has_many :messiers, :class_name => "Astro::Messier"
    has_many :ngcs, :class_name => "Astro::Ngc"

    has_many :observations, :as=>:observable, :class_name=>"Addable::Observation"
    has_many :photos, :through=>:observations

    validate :name, :uniqueness=>true

    def get_name
      return self.name
    end
  end
end