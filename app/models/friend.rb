class Friend < ActiveRecord::Base
  enum ethnicity: [:white, :black, :hispanic, :asian, :south_asian, :caribbean, :indigenous, :other]
  enum gender: [:male, :female, :awesome]
  enum status: [:in_deportation_proceedings, :not_in_deportation_proceedings, :asylum_reciepient, :asylum_application_denied, :legal_permanent_resident, :in_detention, :green_card_holder]
  enum asylum_status: [:asylum_not_eligible, :asylum_eligible, :asylum_application_started, :asylum_application_completed, :asylum_application_submitted, :asylum_granted, :asylum_denied]
  enum work_authorization_status: [:work_authorization_not_eligible, :work_authorization_eligible, :work_authorization_application_started, :work_authorization_application_completed, :work_authorization_application_submitted, :work_authorization_granted, :work_authorization_denied]
  enum sidj_status: [:sidj_not_eligible, :sidj_eligible, :sidj_application_started, :sidj_application_completed, :sidj_application_submitted, :sidj_granted, :sidj_denied]

  validates :first_name, :last_name, presence: true
  validates :a_number, presence: { if: :a_number_available? }, numericality: { if: :a_number_available? }
  validates :a_number, length: { minimum: 8, maximum: 9 }, if: :a_number_available?


  private

  def a_number_available?
    self.no_a_number == false
  end
end