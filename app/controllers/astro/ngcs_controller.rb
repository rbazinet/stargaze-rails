# coding: UTF-8

module Astro
  class NgcsController < ApplicationController
    def show
      @ngc=Astro::Ngc.find(params[:id])
    end
  end
end