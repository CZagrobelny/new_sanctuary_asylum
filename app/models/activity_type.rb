class ActivityType < ApplicationRecord
  validates :name, presence: true

  scope :accompaniment_eligible, -> {
    where(accompaniment_eligible: true)
  }

  scope :eoir_caller_editable, -> {
    where(eoir_caller_editable: true)
  }

  scope :by_name, -> {
    order('name asc')
  }

  def display_name
    name.titlecase
  end

  def display_name_with_accompaniment_eligibility
    if accompaniment_eligible?
      "#{display_name} (Accompaniment Eligible)"
    else
      display_name
    end
  end

  def filing_asylum_application?
    name == 'filing_asylum_application'
  end
end
