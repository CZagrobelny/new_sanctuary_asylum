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

  def print_week_start_end_dates(week)
    Date.commercial(Date.today.year, week.to_i, 1).strftime('%B %-d') +
      ' - ' +
      Date.commercial(Date.today.year, week.to_i, 7).strftime('%B %-d')
  end

  def group_activities_by_week(activities)
    activities.group_by { |a| a.occur_at.strftime('%V') }
  end

  def group_activities_by_day(activities)
    activities.group_by { |a| a.occur_at.to_date }
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
