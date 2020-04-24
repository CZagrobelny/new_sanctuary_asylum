class RegionalAdmin::RemoteReviewActionsController < RegionalAdminController
  def index
    @remote_review_actions = current_region
      .remote_review_actions
      .where('created_at > ?', 1.month.ago)
      .includes(:community, :region, :friend, :user, :application, :draft)
      .order('created_at desc')
      .paginate(page: params[:page])
  end
end
