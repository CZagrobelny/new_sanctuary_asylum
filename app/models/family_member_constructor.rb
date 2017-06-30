class FamilyMemberConstructor
  include ActiveModel::Model

  attr_accessor :friend_id, :relation_id, :relationship
  RELATIONSHIPS = [['Spouse', :spouse], ['Parent', :parent], ['Child', :child]]

  validates :friend_id, :relation_id, :relationship, presence: true

  def initialize(params = {})
    @friend_id = params[:friend_id].to_i
    @relation_id = params[:relation_id].to_i
    @relationship = params[:relationship]
  end

  def run
    return false unless self.valid?
    case relationship
    when 'spouse'
      SpousalRelationship.create(friend_id: friend_id, spouse_id: relation_id)
    when 'parent'
      ParentChildRelationship.create(parent_id: relation_id, child_id: friend_id)
    when 'child'
      ParentChildRelationship.create(parent_id: friend_id, child_id: relation_id)
    end 
  end
end