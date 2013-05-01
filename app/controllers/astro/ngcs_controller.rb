# coding: UTF-8

module Astro
  class NgcsController < ApplicationController
    def show
      @ngc=Astro::Ngc.find(params[:id])
      @votable=@ngc
    end
  end
end