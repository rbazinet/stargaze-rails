module Astro
  class AstroObject < ActiveRecord::Base
    self.abstract_class=true
    @columns = []

    has_many :observations, :class_name=>"User::Observation"

  end
end