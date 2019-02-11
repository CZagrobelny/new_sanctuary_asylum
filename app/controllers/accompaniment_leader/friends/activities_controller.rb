class AccompanimentLeader::Friends::ActivitiesController < AccompanimentLeaderController
  def new
    @activity = friend.activities.new(region_id: current_region.id)
  end

  def create
    @activity = friend.activities.build(activity_params)
    if @activity.save
      flash[:success] = "Activity added for #{friend.name}"
      redirect_to community_accompaniment_leader_activities_path
    else
      flash.now[:error] = "There was an issue adding an activity for #{friend.name}"
      render :new
    end
  end

  private

  def activity_params
    params.require(:activity).permit(
      :activity_type_id,
      :location_id,
      :friend_id,
      :judge_id,
      :occur_at,
      :notes,
      :public_notes
    ).merge(region_id: current_region.id)
  end

  def friend
    Friend.find(params[:friend_id])
  end
end
