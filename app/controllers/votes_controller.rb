# coding: UTF-8

class VotesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_votable

  def add_to_fav
    @votable.liked_by current_user
    respond_to do |format|
      format.js{render :partial => 'shared/favs'}
    end
  end

  def remove_from_fav
    if current_user.voted_as_when_voted_for(@votable)==true
      current_user.unlike @votable
    end
    respond_to do |format|
      format.js{render :partial => 'shared/favs'}
    end
  end

  private
    def load_votable
      @votable=params[:votable_type].constantize.find(params[:votable_id])
    end
end
