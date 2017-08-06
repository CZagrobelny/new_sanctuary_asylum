class AccompanimentsController < ApplicationController

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
      redirect_to accompaniment_leader_activities_path
    else
      redirect_to activities_path
    end
  end
end