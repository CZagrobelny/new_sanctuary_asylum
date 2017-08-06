class AccompanimentLeader::AccompanimentReportsController < AccompanimentLeaderController
  def new
    @accompaniment_report = activity.accompaniment_reports.new
    @activity = activity
  end

  def edit
    @accompaniment_report = accompaniment_report
    @activity = activity
  end

  def create
    @accompaniment_report = activity.accompaniment_reports.new(accompaniment_report_params)
    if @accompaniment_report.save
      flash[:success] = 'Your accompaniment report was created.'
      redirect_to accompaniment_leader_activities_path
    else
      flash[:error] = 'There was an error creating your accompaniement report.'
      render :edit
    end
  end

  def update
    if accompaniment_report.update(accompaniment_report_params)
      flash[:success] = 'Your accompaniment report was saved.'
      redirect_to accompaniment_leader_activities_path
    else
      @activity = activity
      flash[:error] = 'There was an error saving your accompaniement report.'
      render :edit
    end
  end

  def activity
    @activity ||= Activity.find(params[:activity_id])
  end

  def accompaniment_report
    @accompaniment_report ||= AccompanimentReport.find(params[:id])
  end

  private
  def accompaniment_report_params
    params.require(:accompaniment_report).permit( 
      :notes
    ).merge(user_ids: [current_user.id])
  end
end