module DatesHelper
  module_function

  def two_weeks
    if Date.today.cwday >= 5 && !Activity.remaining_this_week?
      week1 = (1.weeks.from_now.beginning_of_week.to_date..1.weeks.from_now.end_of_week.to_date)
      week2 = (2.weeks.from_now.beginning_of_week.to_date..2.weeks.from_now.end_of_week.to_date)
    else
      week1 = (Date.today.beginning_of_week.to_date..Date.today.end_of_week.to_date)
      week2 = (1.weeks.from_now.beginning_of_week.to_date..1.weeks.from_now.end_of_week.to_date)
    end
    [week1, week2]
  end

  def five_weeks
    if Date.today.cwday >= 5 && !Activity.remaining_this_week?
      start_date = 2.weeks.ago.beginning_of_week.to_date
      end_date = 2.weeks.from_now.end_of_week.to_date
    else
      start_date = 3.weeks.ago.beginning_of_week.to_date
      end_date = 2.weeks.from_now.end_of_week.to_date
    end
    [start_date, end_date]
  end
end
