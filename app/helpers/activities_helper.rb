module ActivitiesHelper

  def full_volunteer_details(activity)
    content_tag :ol do
      activity.accompaniements.each do |accompaniement|
        concat content_tag :li, "#{accompaniement.user.name} (#{accompaniement_details(accompaniement)})"
      end
    end
  end

  def accompaniement_details(accompaniement)
    accompaniement_details = [accompaniement.user.phone, accompaniement.user.email]
    accompaniement_details << accompaniement.availability_notes if accompaniement.availability_notes.present?
    accompaniement_details.to_sentence
  end
end
