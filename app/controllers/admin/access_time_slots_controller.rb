class Admin::AccessTimeSlotsController < AdminController
  before_action :require_admin

  def index
    @access_time_slots =  current_community.access_time_slots
  end

  def new
  end

  def create
  end

  def update
    access_time_slot = AccessTimeSlot.find(params[:id])
    if access_time_slot.update!(access_time_slots_params)
      redirect_to community_admin_access_time_slots_path
    end
  end

  def delete
  end

  private

  def access_time_slots_params
    params.require(:access_time_slot).permit(
      :start_time,
      :end_time,
      :use,
      :grantor_id,
      :grantee_id,
    ).merge(community_id: current_community.id)
  end
end
