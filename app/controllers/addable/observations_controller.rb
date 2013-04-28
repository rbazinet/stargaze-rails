# coding: UTF-8

module Addable
  class ObservationsController < ApplicationController
    before_filter :load_observable, :except=>[:show]
    before_filter :authenticate_user!, :except=>[:show]

    def show
      @observation=Addable::Observation.find(params[:id])
      @observable=@observation.observable_type.constantize.find(@observation.observable_id)
      get_name
    end

    def new 
      @observation=@observable.observations.new
    end

    def create
      @observation=@observable.observations.new(params[:addable_observation])
      @observation.user=current_user
      if @observation.save
        redirect_to @observation, notice: "Observation created"
      else
        render :action=>'new'
      end
    end

    private
      def load_observable
        @observable=params[:observable_type].constantize.find(params[:observable_id])
        get_name
      end

      def get_name
        if @observable.class.method_defined? :name
          @name=@observable.name
        elsif @observable.class.method_defined? :messier_number
          @name="M"+@observable.messier_number.to_s
        elsif @observable.class.method_defined? :ngc_number
          @name="NGC"+@observable.ngc_number.to_s
        else
          @name="Unknown object"
        end
      end
  end
end