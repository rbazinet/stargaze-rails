# coding: UTF-8

class CommentsController < ApplicationController
  before_filter :load_commentable
  before_filter :authenticate_user!

  def create
    @commentable.comments.create(params[:comment])
    redirect_to request.referer
  end

  def destroy
  end

  private
    def load_commentable
      @commentable=params[:commentable_type].constantize.find(params[:commentable_id])
    end

end