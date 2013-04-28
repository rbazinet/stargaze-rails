module Astro
  class Messier < ActiveRecord::Base
    set_table_name 'astro_messier'

    acts_as_commentable

    belongs_to :constellation, :class_name => "Astro::Constellation"

    has_many :observations, :as=>:observable, :class_name=>"Addable::Observation"
    has_many :photos, :through=>:observations
  end
end