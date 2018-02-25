class Detention < ApplicationRecord
  belongs_to :friend
  belongs_to :location
  CASE_STATUSES = ['immigration_court', 'bia', 'circuit_court', 'other'].map{|status| [status.titlecase, status]}
  validates :friend_id, presence: true

  def display_case_status
    if self.case_status
      if self.case_status == 'other'
        self.other_case_status
      else
        self.case_status.titlecase
      end
    end
  end

end
