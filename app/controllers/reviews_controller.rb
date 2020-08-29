class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_access_to_community
  before_action :require_admin_or_access_to_friend, only: [:show]
  before_action :require_admin_or_remote_lawyer, only: [:new, :create]
  before_action :require_review_author, only: [:edit, :update, :destroy]

  def new
    @review = draft.reviews.by_user(current_user).first
    if @review
      flash[:alert] = 'Review already created.'
      redirect_to edit_community_friend_draft_review_path(friend.community.slug, friend, draft, review)
    else
      @review = Review.new
      friend
    end
  end

  def create
    if create_review_and_set_status
      if friend.users.where(user_friend_associations: { remote: false }).present?
        ReviewMailer.review_added_email(review).deliver_now
      end
      flash[:success] = 'Review created.'
      render_friend_page
    else
      review
      friend
      draft
      flash.now[:error] = 'Review failed to save.'
      render :new
    end
  end

  def show
    review
  rescue ActiveRecord::RecordNotFound => e
    flash[:error] = 'We could not find this review. An admin may have removed it.'
    redirect_to community_friend_path(current_community.slug, friend, tab: '#documents')
  end

  def edit
    review
    friend
    draft
  end

  def update
    if review.update(review_params)
      flash[:success] = 'Review updated.'
      render_friend_page
    else
      draft
      review
      friend
      flash.now[:error] = 'Review failed to save.'
      render :edit
    end
  end

  def destroy
    if review.destroy
      flash[:success] = 'Review successfully deleted.'
    else
      flash[:error] = 'There was an issue deleting this review.'
    end
    redirect_to edit_community_admin_friend_path(current_community.slug, friend, tab: '#documents')
  end

  private

  def review
    @review ||= draft.reviews.find(params[:id])
  end

  def draft
    @draft ||= friend.drafts.find(params[:draft_id])
  end

  def application
    @application ||= draft.application
  end

  def friend
    @friend ||= Friend.find(params[:friend_id])
  end

  def create_review_and_set_status
    ActiveRecord::Base.transaction do
      @review = draft.reviews.create!(
        review_params.merge(user: current_user)
      )
      draft.update!(status: 'review_added')
      application.update!(status: 'review_added')
      RemoteReviewAction.create!(
        action: 'review_added',
        user_id: current_user.id,
        friend_id: friend.id,
        community_id: friend.community_id,
        region_id: friend.region_id,
        application_id: application.id,
        draft_id: draft.id,
      )
    end
    true
  rescue
    false
  end

  def render_friend_page
    if current_user.regional_admin? && params[:remote_clinic].present?
      redirect_to regional_admin_region_friend_path(friend.region, friend)
    elsif current_user.remote_clinic_lawyer?
      redirect_to remote_clinic_friend_path(friend)
    else
      redirect_to edit_community_admin_friend_path(current_community.slug, friend, tab: '#documents')
    end
  end

  def require_review_author
    not_found unless review.user == current_user
  end

  def review_params
    params.require(:review).permit(:notes)
  end
end
