class PartnerRelationship < ActiveRecord::Base
  belongs_to :friend
  belongs_to :partner, class_name: 'Friend'

  validates :friend_id, :partner_id, presence: true
end
