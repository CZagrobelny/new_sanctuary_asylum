module AccompanimentHelper
  def accompaniment_user_details(accompaniment)
    user = accompaniment.user
    [user.phone, user.email].tap do |details|
      details << user.volunteer_type.humanize.titleize if user.volunteer?
      details << accompaniment.availability_notes if accompaniment.availability_notes.present?
    end
  end

  def print_week_start_end_dates(week)
    Date.commercial(Date.today.year, week, 1).strftime('%B %-d') +
      ' - ' +
      Date.commercial(Date.today.year, week, 7).strftime('%B %-d')
  end

  def group_activities_by_week(activities)
    activities.group_by { |a| a.occur_at.strftime('%V') }
  end

  def group_activities_by_day(activities)
    activities.group_by { |a| a.occur_at.to_date }
  end
end
