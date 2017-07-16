module ActivitiesHelper

  def full_volunteer_details(activity)
    content_tag :ol do
      activity.accompaniements.each do |accompaniement|
        concat content_tag :li, accompaniement_details(accompaniement)
      end
    end
  end

  def accompaniement_details(accompaniement)
    content_tag :div do
      user_details = "#{accompaniement.user.name}, <i>#{accompaniement.user.phone}, #{accompaniement.user.email}</i>"
      user_details += " -- #{accompaniement.availability_notes}" if accompaniement.availability_notes.present?
      user_details.html_safe
    end
  end
end
