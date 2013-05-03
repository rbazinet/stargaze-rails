# coding: UTF-8

class HomeController < ApplicationController
  def index
  end
  def info
  end

  def show #is the action for user home page
  	@user=User.find(params[:id])
  end
end
