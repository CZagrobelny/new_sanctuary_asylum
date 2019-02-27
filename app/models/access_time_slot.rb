class AccessTimeSlot < ApplicationRecord
  USES = %w[data_entry clinic_support]

  belongs_to :grantee, class_name: 'User'
  belongs_to :grantor, class_name: 'User'
  belongs_to :community

  validates_presence_of :start_time, :end_time, :use, :grantor_id, :grantee_id, :community_id

  # TO DO: add validation for duration
end
