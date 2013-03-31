module User
  class Observation < ActiveRecord::Base
    set_table_name 'user_observation'

    belongs_to :user, :class_name => "User"
    belongs_to :observable, :polymorphic => true
    has_many :photos, :class_name => "User::Photo"

    validates :user_id, :description, :eq_used, :observation_date, :conditions, :name, :presence=>true
    validates :user_id, :numericality=>{:only_integer=>true}

  end
end
