class SpousalRelationship < ActiveRecord::Base
  attr_accessor :first_spouse_id, :second_spouse_id
  belongs_to :friend

  validates :first_spouse_id, :second_spouse_id, presence: true 
end