class Admin::ReportsController < AdminController
  def new
  end

  def create
    if report.valid?
      #Implement something like:
      # respond_to do |format|
      #   format.html
      #   format.csv { send_data report.csv_string, filename: report.filename }
      # end
    else
      # render an error and :new
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