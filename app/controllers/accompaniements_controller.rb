class AccompaniementsController < ApplicationController

  def create
    if params[:attending] == 'true'
      accompaniement = Accompaniement.new(accompaniement_params)
      if accompaniement.save
        flash[:success] = 'RSVP successful.'
        redirect_to activities_path
      end
    else
      redirect_to activities_path
    end
  end

  def update
    accompaniement = Accompaniement.find(params[:id])
    if params['attending'] == 'true'
      if accompaniement.update(accompaniement_params)
        flash[:success] = 'RSVP updated successfully.'
        redirect_to activities_path
      end
    else
      if accompaniement.destroy
        flash[:success] = 'RSVP deleted.'
        redirect_to activities_path
      end
    end
  end

  def accompaniement_params
    params.require(:accompaniement).permit( 
      :availability_notes,
      :user_id,
      :activity_id
    )
  end
end