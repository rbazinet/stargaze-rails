# coding: UTF-8

module Astro
  class StarsController < ApplicationController
    def show
      @star=Astro::Star.find(params[:id])
      @votable=@star
    end
  end
end