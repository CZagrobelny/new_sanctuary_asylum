class Admin::ReportsController < AdminController
  def new
    @report = Report.new
  end

  def create
    if report.valid?
      if report.has_data?
        #Implement something like:
        # respond_to do |format|
        #   format.html
        #   format.csv { send_data report.csv_string, filename: report.filename }
        # end
      else
        # flash info message letting them know that there are no records for the selected date range and render :new
      end
    else
      flash.now[:error] = 'Report not created.'
      render :new
    end
  end

  def report
    @report ||= case report_params['type']
                when 'activity'
                  ActivityReport.new(report_params)
                when 'event'
                else
                  Report.new(report_params)
                end
  end

  private

  def report_params
    params.require(:report).permit(
      :start_date,
      :end_date,
      :type
    )
  end
end