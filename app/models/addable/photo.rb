module Addable
  class Photo < ActiveRecord::Base
    set_table_name 'user_photo'

    belongs_to :user, :class_name => "User"
    belongs_to :observation, :class_name => "User::Observation"

    has_attached_file :payload, :styles => { :thumb => "70x70>"}

    validates :user_id, :observation_id, :presence=>true
    validates :user_id, :observation_id, :numericality=>{:only_integer=>true}

  end
end
