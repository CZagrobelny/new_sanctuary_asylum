class AccompanimentsController < ApplicationController

  def create
    if params[:attending] == 'true'
      accompaniment = Accompaniment.new(accompaniment_params)
      if accompaniment.save
        flash[:success] = 'Your RSVP was successful.'
        redirect_to activities_path
      end
    else
      redirect_to activities_path
    end
  end

  def update
    accompaniment = Accompaniment.find(params[:id])
    if params['attending'] == 'true'
      if accompaniment.update(accompaniment_params)
        flash[:success] = 'RSVP updated successfully.'
        redirect_to activities_path
      end
    else
      if accompaniment.destroy
        flash[:success] = 'Your RSVP was deleted.'
        redirect_to activities_path
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
end