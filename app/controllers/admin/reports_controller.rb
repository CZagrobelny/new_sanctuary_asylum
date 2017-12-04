class Admin::ReportsController < AdminController
  def new
  end

  def create
    if report
      if report.valid?
        if report.has_data?
          #Implement something like:
          # respond_to do |format|
          #   format.html
          #   format.csv { send_data report.csv_string, filename: report.filename }
          # end
        else
          #message letting them know that there are no records for the selected date range and render :new
      else
        #error message about missing date params and render :new
    else
      # add the an error message about selecting type of report error and render :new
    end
  end

  private

  def report
    case report_params['type']
    when 'activity'
      @report ||= ActivityReport.new(report_params)
    when 'event'
    end
  end

  def report_params
    params.require(:report).permit(
      :start_date,
      :end_date,
      :type
    )
  end
end