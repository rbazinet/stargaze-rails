module Astro
  class Ngc < ActiveRecord::Base
    set_table_name 'astro_ngc'

    acts_as_commentable
    acts_as_votable

    belongs_to :constellation, :class_name => "Astro::Constellation"

    has_many :observations, :as=>:observable, :class_name=>"Addable::Observation"
    has_many :photos, :through=>:observations

    def get_name
      return "NGC"+self.ngc_number.to_s
    end
  end
end