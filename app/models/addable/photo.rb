module Addable
  class Photo < ActiveRecord::Base
    set_table_name 'user_photo'

    acts_as_commentable
    acts_as_votable

    belongs_to :observation, :class_name => "Addable::Observation"

    has_attached_file :payload, :styles => { :thumb => "70x70>"}

    attr_accessible :payload, :observation_id

    #validates :observation_id, :presence=>true
    #validates :observation_id, :numericality=>{:only_integer=>true}

  end
end
