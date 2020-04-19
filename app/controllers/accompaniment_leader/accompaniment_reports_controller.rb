class AccompanimentLeader::AccompanimentReportsController < AccompanimentLeaderController
  def new
    @accompaniment_report = activity.accompaniment_reports.new(friend: friend)
  end

  def edit
    accompaniment_report
    activity
  end

  def create
    @accompaniment_report = activity.accompaniment_reports.new(accompaniment_report_params)
    if accompaniment_report.save
      flash[:success] = 'Your accompaniment leader notes were added.'
      redirect_to community_accompaniment_leader_activities_path(current_community.slug)
    else
      flash.now[:error] = 'There was an error saving your accompaniment leader notes.'
      render :edit
    end
  end

  def update
    if accompaniment_report.update(accompaniment_report_params)
      flash[:success] = 'Your accompaniment leader notes were saved.'
      redirect_to community_accompaniment_leader_activities_path(current_community.slug)
    else
      activity
      flash.now[:error] = 'There was an error saving your accompaniment leader notes.'
      render :edit
    end
  end

  private

  def accompaniment_report_params
    params.require(:accompaniment_report).permit(
      :notes,
      :outcome_of_hearing,
      friend_attributes: [:has_a_lawyer, :judge_imposed_i589_deadline, :lawyer_name]
    ).merge(user_id: current_user.id, friend_id: friend.id)
  end

  def activity
    @activity ||= current_region.activities.find(params[:activity_id])
  end

  def friend
    @friend ||= activity.friend
  end

  def accompaniment_report
    @accompaniment_report ||= AccompanimentReport.find(params[:id])
  end
end
