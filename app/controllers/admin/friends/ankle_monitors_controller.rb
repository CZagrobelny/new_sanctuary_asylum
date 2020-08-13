class Admin::Friends::AnkleMonitorsController < AdminController
  def new
    @ankle_monitor = friend.ankle_monitors.new
    render_modal
  end

  def create
    @ankle_monitor = friend.ankle_monitors.build(ankle_monitor_params)
    if @ankle_monitor.save
      render_success
    else
      render_modal
    end
  end

  def edit
    render_modal
  end

  def update
    if ankle_monitor.update(ankle_monitor_params)
      render_success
    else
      render_modal
    end
  end

  def destroy
    render_success if ankle_monitor.destroy
  end

  private

  def ankle_monitor
    @ankle_monitor ||= AnkleMonitor.find(params[:id])
  end

  def friend
    @friend ||= current_community.friends.find(params[:friend_id])
  end

  def ankle_monitor_params
    params.require(:ankle_monitor).permit(
      :friend_id,
      :date_applied,
      :date_removed,
      :notes,
      :bi_smart_link,
    )
  end

  def render_modal
    respond_to do |format|
      format.js { render template: 'admin/friends/ankle_monitors/modal', locals: { friend: friend, ankle_monitor: ankle_monitor } }
    end
  end

  def render_success
    respond_to do |format|
      format.js { render template: 'admin/friends/ankle_monitors/list', locals: { friend: friend } }
    end
  end
end
