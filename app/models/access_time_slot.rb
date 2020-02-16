class AccessTimeSlot < ApplicationRecord
  DATA_ENTRY_USES = %w[data_entry clinic_support anti_detention]
  EOIR_USES = %w[eoir_caller]
  USES = DATA_ENTRY_USES + EOIR_USES

  belongs_to :grantee, class_name: 'User'
  belongs_to :grantor, class_name: 'User'
  belongs_to :community

  validates_presence_of :start_time, :end_time, :use, :grantor_id, :grantee_id, :community_id
  validate :end_time_is_after_start_time
  validate :time_range_under_ten_hours
  validate :permitted_use_for_grantee_user_role

  scope :active, -> { where('start_time < ? AND end_time > ?', Time.now, Time.now) }

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

  def permitted_use_for_grantee_user_role
    return unless grantee
    case grantee.role
    when 'eoir_caller'
      unless EOIR_USES.include?(use)
        errors.add(:base, "Only users with 'eoir caller' role can be assigned an access timeslot for #{use}")
      end
    when 'data_entry'
      unless DATA_ENTRY_USES.include?(use)
        errors.add(:base, "Only users with 'data entry' role can be assigned an access timeslot for #{use}")
      end
    else
      errors.add(:base, "Only 'eoir caller' and 'data entry' users can be assigned an access timeslot")
    end
  end
end
