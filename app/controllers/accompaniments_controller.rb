class AccompanimentsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_access_to_community
  before_action :require_primary_community
  before_action :require_accompaniment_owner, only: [:update]

  def create
    if params[:attending] == 'true'
      accompaniment = Accompaniment.new(accompaniment_params)
      if accompaniment.save
        flash[:success] = 'Your RSVP was successful.'
      else
        flash[:error] = accompaniment.errors.full_messages.to_sentence
      end
    end
    redirect_activities
  end

  def update
    accompaniment = Accompaniment.find(params[:id])
    if params['attending'] == 'true'
      flash[:success] = 'RSVP updated successfully.' if accompaniment.update(accompaniment_params)
    elsif accompaniment.destroy
      flash[:success] = 'Your RSVP was deleted.'
    end
    redirect_activities
  end

  private

  def require_accompaniment_owner
    not_found unless current_user.id.to_s == accompaniment_params[:user_id]
  end

  def accompaniment_params
    params.require(:accompaniment).permit(
      :availability_notes,
      :user_id,
      :activity_id
    )
  end

  def redirect_activities
    if current_user.accompaniment_leader?
      redirect_to community_accompaniment_leader_activities_path(current_community.slug)
    else
      redirect_to community_activities_path(current_community.slug)
    end
  end
end
