class PopulateActivityTypesAndAssignTypeIds < ActiveRecord::Migration[5.0]
  def change
    eligible_events = %w[master_calendar_hearing
                         individual_hearing
                         special_accompaniment
                         check_in
                         high_risk_ice_check_in
                         family_court
                         criminal_court
                         bond_hearing
                         fingerprinting].freeze

    ineligible_events = %w[filing_asylum_application
                           asylum_granted
                           filing_work_permit
                           detained
                           guardianship_requested
                           sijs_special_findings_form_finished
                           sijs_application_submitted
                           sijs_granted
                           sijs_denied
                           change_of_venue_submitted
                           foia_request_submitted
                           foia_recieved
                           I_130_sent
                           stay_of_deportation_filed
                           u_visa_filed
                           habeas_corpus_filed].freeze

    for event in eligible_events do
      new_activity_type = ActivityType.new(name: event, accompaniment_eligible: true)
      new_activity_type.save
    end
    for event in ineligible_events do
      new_activity_type = ActivityType.new(name: event, accompaniment_eligible: false)
      new_activity_type.save
    end

    all_activities = Activity.all
    all_activities.each do |activity|
      activity.activity_type = ActivityType.find_by(name: activity.event)
      activity.save
    end
  end
end
