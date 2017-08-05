module ActivitiesHelper

  def full_volunteer_details(activity)
    content_tag :ol do
      activity.accompaniments.each do |accompaniment|
        concat content_tag :li, accompaniment_details(accompaniment)
      end
    end
  end

  def accompaniment_details(accompaniment)
    content_tag :div do
      user_details = "#{accompaniment.user.name}, <i>#{accompaniment.user.phone}, #{accompaniment.user.email}</i>"
      user_details += " -- #{accompaniment.availability_notes}" if accompaniment.availability_notes.present?
      user_details.html_safe
    end
  end
end
