module AccompanimentHelper
  def accompaniment_user_details(accompaniment)
    user = accompaniment.user
    [user.phone, user.email].tap do |details|
      details << user.volunteer_type.humanize.titleize if user.volunteer?
      details << accompaniment.availability_notes if accompaniment.availability_notes.present?
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

  def calendar_activity_title(activity)
    title = "#{activity.activity_type.name.titlecase} for #{activity.friend.first_name}"
    title << "at #{activity.location.name}" if activity.location.present?
  end
end
