# coding: UTF-8

module Astro
  class MessiersController < ApplicationController
    def show
      @messier=Astro::Messier.find(params[:id])
    end
  end
end