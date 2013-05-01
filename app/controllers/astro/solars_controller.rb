# coding: UTF-8

module Astro
  class SolarsController < ApplicationController
    def index
      @solars=Astro::Solar.all
    end
    def show
      @solar=Astro::Solar.find(params[:id])
      @votable=@solar
    end
  end
end