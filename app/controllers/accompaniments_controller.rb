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
        render_activities
      end
    else
      render_activities
    end
  end

  def update
    accompaniment = Accompaniment.find(params[:id])
    if params['attending'] == 'true'
      if accompaniment.update(accompaniment_params)
        flash[:success] = 'RSVP updated successfully.'
        render_activities
      end
    else
      if accompaniment.destroy
        flash[:success] = 'Your RSVP was deleted.'
        render_activities
      end
    end
  end

  def accompaniment_params
    params.require(:accompaniment).permit(
      :availability_notes,
      :user_id,
      :activity_id
    )
  end

  def render_activities
    if current_user.accompaniment_leader?
      redirect_to community_accompaniment_leader_activities_path(current_community.slug)
    else
      redirect_to community_activities_path(current_community.slug)
    end
  end

  private

  def require_accompaniment_owner
    not_found unless current_user.id.to_s == accompaniment_params[:user_id]
  end
end
