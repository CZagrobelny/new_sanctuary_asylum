class Admin::FriendsController < ApplicationController
  def index
    @friends = Friend.all
  end

  def new
    @friend = Friend.new
    @friend_language = @friend.languages.build 
  end

  def edit
    @friend ||= Friend.find(params[:id])
  end

  def create
    @friend = Friend.new(friend_params)
    if @friend.save
      flash[:success] = 'Friend record saved.'
      redirect_to edit_admin_friend_path(@friend)
    else
      flash.now[:error] = 'Friend record not saved.'
      render :new
    end
  end

  def update
    @friend = Friend.find(params[:id])
    @friend.update(friend_params)
    render :edit
  end

  private
  def friend_params
    params.require(:friend).permit(
      :first_name,
      :last_name,
      :middle_name,
      :email,
      :phone,
      :a_number,
      :no_a_number,
      :ethnicity,
      :other_ethnicity,
      :gender,
      :date_of_birth,
      :status,
      :date_of_entry,
      :notes,
      :asylum_status,
      :asylum_notes,
      :date_asylum_application_submitted,
      :lawyer_notes,
      :work_authorization_notes,
      :date_eligible_to_apply_for_work_authorization,
      :date_work_authorization_submitted,
      :work_authorization_status,
      :sidj_status,
      :date_sidj_submitted,
      :sidj_notes,
      :country_id,
      :language_ids => []
    )
  end
end
