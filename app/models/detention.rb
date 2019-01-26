class Detention < ApplicationRecord
  belongs_to :friend
  belongs_to :location
  CASE_STATUSES = %w[immigration_court bia circuit_court other].map { |status| [status.titlecase, status] }
  validates :friend_id, presence: true

  def display_case_status
    return unless case_status
    return other_case_status if case_status == 'other'

    case_status.titlecase
  end
end
