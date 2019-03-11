class AccessTimeSlot < ApplicationRecord
  USES = %w[data_entry clinic_support anti_detention]

  belongs_to :grantee, class_name: 'User'
  belongs_to :grantor, class_name: 'User'
  belongs_to :community

  validates_presence_of :start_time, :end_time, :use, :grantor_id, :grantee_id, :community_id
  validate :end_time_is_after_start_time
  validate :time_range_under_ten_hours

  private

  def end_time_is_after_start_time
    return if end_time.blank? || start_time.blank?

    if end_time < start_time
      errors.add(:end_time, "cannot be before the start time")
    end
  end

  def time_range_under_ten_hours
    return if end_time.blank? || start_time.blank?

    if end_time - start_time > 10.hours
      errors.add(:base, "Time range cannot exceed 10 hours.")
    end
  end
end
