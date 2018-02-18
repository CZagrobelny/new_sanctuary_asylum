class FamilyMemberConstructor
  include ActiveModel::Model

  attr_accessor :friend_id, :relation_id, :relationship
  RELATIONSHIPS = [['Spouse', :spouse], ['Parent', :parent], ['Child', :child], ['Sibling', :sibling], ['Partner', :partner]]

  validates :friend_id, :relation_id, :relationship, presence: true

  def initialize(params = {})
    @friend_id = params[:friend_id].present? ? params[:friend_id].to_i : nil
    @relation_id = params[:relation_id].present? ? params[:relation_id].to_i : nil
    @relationship = params[:relationship] || nil
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
    when 'sibling'
      SiblingRelationship.create(friend_id: friend_id, sibling_id: relation_id)
    when 'partner'
      PartnerRelationship.create(friend_id: friend_id, partner_id: relation_id)
    end
  end
end
