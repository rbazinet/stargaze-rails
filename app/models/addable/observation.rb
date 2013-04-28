module Addable
  class Observation < ActiveRecord::Base
    set_table_name 'user_observation'

    acts_as_commentable
    acts_as_votable

    belongs_to :user, :class_name => "User"
    belongs_to :observable, :polymorphic => true
    has_many :photos, :class_name => "Addable::Photo"

    accepts_nested_attributes_for :photos

    validates :user_id, :description, :eq_used, :observation_date, :conditions, :name, :presence=>true
    validates :user_id, :numericality=>{:only_integer=>true}

    attr_accessible :name, :description, :eq_used, :conditions, :observation_date, :photos_attributes
  end
end
