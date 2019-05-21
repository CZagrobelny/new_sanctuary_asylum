class Admin::FriendsController < AdminController
  def index
    filter_clinic_wait_list_priorities = params.dig('filterrific', 'filter_clinic_wait_list_priority')
    if filter_clinic_wait_list_priorities.present?
      params['filterrific']['filter_clinic_wait_list_priority'] = filter_clinic_wait_list_priorities.reject!(&:empty?)
    end

    @filterrific = initialize_filterrific(Friend,
                                          params[:filterrific],
                                          default_filter_params: { sorted_by: 'created_at_desc' },
                                          select_options: {
                                            sorted_by: Friend.options_for_sorted_by,
                                            filter_border_crossing_status: Friend::BORDER_CROSSING_STATUSES,
                                            filter_clinic_wait_list_priority: Friend.clinic_wait_list_priorities.map { |key, value| [key.humanize, key] }},
                                          persistence_id: false)

    @friends = current_community.friends.filterrific_find(@filterrific).paginate(page: params[:page])
  end

  def new
    @friend = current_community.friends.new
  end

  def edit
    @friend = friend
    @current_tab = current_tab
  end

  def create
    @friend = current_community.friends.new(friend_params)
    if friend.save
      flash[:success] = 'Friend record saved.'
      redirect_to edit_community_admin_friend_path(current_community, @friend)
    else
      flash.now[:error] = 'Friend record not saved.'
      render :new
    end
  end

  def update
    if params['manage_drafts'].present?
      update_and_render_drafts
    elsif friend.update(friend_params)
      flash[:success] = 'Friend record saved.'
      redirect_to edit_community_admin_friend_path(current_community, @friend, tab: current_tab)
    else
      flash.now[:error] = 'Friend record not saved.'
      render :edit
    end
  end

  def destroy
    if friend.destroy
      flash[:success] = 'Friend record destroyed.'
    else
      flash[:error] = 'Friend record has a Draft and/or Activities. It cannot be deleted until these are removed.'
    end
    redirect_to community_admin_friends_path(current_community, query: params[:query])
  end

  private

  def friend
    @friend ||= current_community.friends.find(params[:id])
  end

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
      :border_crossing_status,
      :border_queue_number,
      :notes,
      :asylum_status,
      :asylum_notes,
      :date_asylum_application_submitted,
      :lawyer_notes,
      :work_authorization_notes,
      :date_eligible_to_apply_for_work_authorization,
      :date_work_authorization_submitted,
      :work_authorization_status,
      :sijs_status,
      :date_sijs_submitted,
      :sijs_notes,
      :sijs_lawyer,
      :country_id,
      :lawyer_represented_by,
      :lawyer_referred_to,
      :zip_code,
      :jail_id,
      :criminal_conviction,
      :criminal_conviction_notes,
      :final_order_of_removal,
      :has_a_lawyer_for_detention,
      :bonded_out_by_nsc,
      :bond_amount,
      :date_bonded_out,
      :bonded_out_by,
      :city,
      :state,
      :date_foia_request_submitted,
      :foia_request_notes,
      :sponsor_name,
      :sponsor_phone_number,
      :sponsor_relationship,
      :intake_notes,
      :must_be_seen_by,
      :intake_date,
      :clinic_wait_list_priority,
      language_ids: [],
      user_ids: []
    ).merge(community_id: current_community.id, region_id: current_region.id)
  end

  def update_and_render_drafts
    if friend.update(friend_params)
      redirect_to community_friend_drafts_path(current_community, friend)
    else
      flash.now[:error] = 'Please fill in all required friend fields before managing documents.'
      render :edit
    end
  end

  def current_tab
    # TODO: See if params[:tab] is ever an empty string, otherwise can remove the presence
    params[:tab].presence || '#basic'
  end
end
