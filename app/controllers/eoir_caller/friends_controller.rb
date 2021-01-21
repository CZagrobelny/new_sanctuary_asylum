class EoirCaller::FriendsController < EoirCallerController
  before_action :restrict_access_to_archived_friend

  def update
    if @friend.update(friend_params)
      flash[:success] = 'Friend record saved.'
    else
      flash[:error] = 'There was an issue saving the Friend record.'
    end
    redirect_to community_eoir_caller_search_index_path(
      friend: { a_number: @friend.a_number }
    )
  end

  private
  def friend
    @friend = current_community.friends.find(params[:id])
  end

  def friend_params
    params.require(:friend).permit(
      :first_name,
      :middle_name,
      :last_name,
      :a_number,
      :phone,
      :email,
      :gender,
      :ethnicity,
      :other_ethnicity,
      :country_id,
      :zip_code,
      :city,
      :state,
      :date_of_birth,
      :status,
      :eoir_case_status,
      :famu_docket,
      :no_record_in_eoir,
      :order_of_supervision,
      :date_of_entry,
      :judge_imposed_i589_deadline,
      language_ids: [],
    )
  end
end
