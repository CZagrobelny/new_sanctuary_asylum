require 'csv'
class Admin::ReportsController < AdminController
  before_action :require_primary_community

  def new
    @report = Report.new
  end

  def create
    if report.valid?
      if report.has_data?
         send_data report.csv_string, type: 'text/csv; charset=iso-8859-1; header=present', disposition: "attachment; filename=#{report.csv_filename}", type: :csv
      else
        flash.now[:notice] = 'No records found for that date range.'
        render :new
      end
    else
      flash.now[:error] = 'Report not created.'
      render :new
    end
  end

  def report
    @report ||= case report_params['type']
                when 'activity'
                  ActivityReport.new(report_params.merge(community_and_region_params))
                when 'event'
                  EventReport.new(report_params.merge(community_and_region_params))
                else
                  Report.new(report_params.merge(community_and_region_params))
                end
  end

  private

  def community_and_region_params
    { community_id: current_community.id, region_id: current_region.id }
  end

  def report_params
    params.require(:report).permit(
      :start_date,
      :end_date,
      :type
    )
  end
end