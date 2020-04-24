module AccompanimentHelper
  def accompaniment_user_details(accompaniment)
    user = accompaniment.user
    languages = user.languages.map { |language| language.name.titleize }
    [user.phone, user.email].tap do |details|
      if languages.present?
        details << "Languages: #{languages.join(', ')}"
      end
      if accompaniment.availability_notes.present?
        details << "Notes: #{accompaniment.availability_notes}"
      end
    end
  end

  def volunteers_needed(activity)
    if activity.activity_type.cap.present?
      pluralize(activity.activity_type.cap - activity.volunteer_accompaniments.count, 'volunteer') + ' needed.'
    end
  end

  def attending_summary(activity)
    attending = activity.accompaniment_leader_accompaniments.map { |accompaniment| accompaniment.user.first_name }
    attending << pluralize(activity.volunteer_accompaniments.count, 'volunteer')
    "(#{attending.join(', ')})"
  end
end
