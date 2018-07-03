class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin_or_access_to_friend, only: [:show]
  before_action :require_regional_admin_or_remote_lawyer_with_access_to_friend, only: [:new, :create]
  before_action :require_review_author, only: [:edit, :update]

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
    @review = draft.reviews.new(review_params.merge(user: current_user))
    if review.save
      draft.update(status: :changes_requested)
      draft.application.update(status: :changes_requested)
      flash[:success] = 'Review created.'
      render_friend_page
    else
      friend
      flash.now[:error] = 'Review failed to save. Did you already create one?'
      render :new
    end
  end

  def show
    review
  end

  def edit
    review
    friend
    draft
  end

  def update
    if review.update_attributes(review_params)
      flash[:success] = 'Review updated.'
      render_friend_page
    else
      flash.now[:error] = 'Review failed to save. Did you already create one?'
      render :edit
    end
  end

  private

  def review
    @review ||= Review.find(params[:id])
  end

  def draft
    @draft ||= Draft.find(params[:draft_id])
  end

  def friend
    @friend ||= draft.application.friend
  end

  def render_friend_page
    if current_user.regional_admin?
      redirect_to regional_admin_region_friend_path(friend.region, friend)
    elsif current_user.remote_clinic_lawyer?
      redirect_to remote_clinic_friend_path(friend)
    else
      redirect_to edit_community_admin_friend_path(current_community.slug, friend, tab: '#documents')
    end
  end

  def require_review_author
    unless review.user == current_user
      not_found
    end
  end

  def review_params
    params.require(:review).permit(:notes)
  end
end
