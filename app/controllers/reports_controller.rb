class ReportsController < ApplicationController
  def new
  end

  def create
    #Implement something like:
    # respond_to do |format|
    #   format.html
    #   format.csv { send_data csv_string, filename: filename }
    # end
    #
  end

  private

  def csv_string
    case report['type']
    when 'activity'
      activities = Activity.includes(:location, :judge)
                            .between_dates(start_date: params['start_date'], end_date: params['end_date'])
      # ActivityReport.generate(activities)
    when 'event'

    end
  end

  def csv_filename
    type = report['type'].pluralize
    start_date = params['start_date'].strftime('%-m.%-d.%Y')
    end_date = params['end_date'].strftime('%-m.%-d.%Y')
    "#{type} #{start_date}-#{end_date}.csv"
  end

  def report_params
    params..require(:friend_event_attendance).permit(
      :start_date,
      :end_date,
      :type
    )
  end
end