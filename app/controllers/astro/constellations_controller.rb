# coding: UTF-8

module Astro
  class ConstellationsController < ApplicationController
    def index
      @constellations=Astro::Constellation.all
    end
    def show
      @constellation=Astro::Constellation.find(params[:id])
      @votable=@constellation
    end
  end
end