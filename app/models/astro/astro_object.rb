module Astro
  class AstroObject < ActiveRecord::Base
    self.abstract_class=true
    @columns = []
  end
end