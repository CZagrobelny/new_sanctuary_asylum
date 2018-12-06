class PopulateActivityTypesAndAssignTypeIds < ActiveRecord::Migration[5.0]
  def change
    eligible_events = Activity::ACCOMPANIMENT_ELIGIBLE_EVENTS
    ineligible_events = Activity::NON_ACCOMPANIMENT_ELIGIBLE_EVENTS

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
