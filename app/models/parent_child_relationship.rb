class ParentChildRelationship < ActiveRecord::Base
  belongs_to :parent, class_name: 'Friend', foreign_key: 'parent_id'
  belongs_to :child, class_name: 'Friend', foreign_key: 'child_id'
  
  validates :parent_id, :child_id, presence: true 
end