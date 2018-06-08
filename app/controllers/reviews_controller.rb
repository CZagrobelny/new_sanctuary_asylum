class ReviewsController < ApplicationController
  def new
    @draft = Draft.find(params[:draft_id])
    @friend = Friend.find(params[:friend_id])
    @review = @draft.reviews.where(user: current_user).first
    if @review
      # TODO: When review#edit exists, redirect there instead
      flash[:alert] = 'Review already created.'
      redirect_to community_friend_draft_review_path(
        current_community.slug,
        @draft.application.friend,
        @draft,
        @review
      )
    else
      @review = Review.new
    end
  end

  def create
    @draft = Draft.find(params[:draft_id])
    @friend = @draft.application.friend
    user = current_user
    @review = @draft.reviews.new(review_params.merge(user: user))
    if @review.save
      redirect_to community_friend_draft_review_path(
        current_community.slug,
        @friend,
        @draft,
        @review
      )
    else
      flash.now[:error] = 'Review failed to save. Did you already create one?'
      render :new
    end
  end

  def show
    @review = Review.find(params[:id])
  end

  private

  def review_params
    params.require(:review).permit(:notes)
  end
end
