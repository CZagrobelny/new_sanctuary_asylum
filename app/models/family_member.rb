class FamilyMember < ActiveRecord::Base
  enum relationship: [:partner, :spouse, :parent_or_step_parent, :child_or_step_child]
  has_many :friends

  validates :friend_id, :relation_id, :relationship, presence: true 
end
