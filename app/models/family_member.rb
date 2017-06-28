class FamilyMember
  include ActiveModel::Model

  attr_accessor :friend_id, :relation_id, :relationship
  RELATIONSHIPS = [['Spouse', :spouse], ['Parent', :parent], ['Child', :child]]

  validates :friend_id, :relation_id, :relationship, presence: true

  def self.create(params)
    case params[:relationship]
    when 'spouse'
      SpousalRelationship.create(first_spouse_id: params[:friend_id], second_spouse_id: params[:related_id])
    when 'parent'
      ParentChildRelationship.create(parent_id: params[:relation_id].to_i, child_id: params[:friend_id].to_i)
    when 'child'
      ParentChildRelationship.create(parent_id: params[:friend_id].to_i, child_id: params[:relation_id].to_i)
    end 
  end
end