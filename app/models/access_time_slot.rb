class AccessTimeSlot < ApplicationRecord
  USE_TYPES = %w[data_entry clinic_support]

  belongs_to :grantee, class_name: 'User'
  belongs_to :grantor, class_name: 'User'

  validates_presence_of :start_time, :end_time, :use, :grantor_id, :grantee_id
end
