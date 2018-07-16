class Admin::FriendsController < AdminController
  def index
    @friends = if params[:query].present?
                 search.perform
               else
                 friend_index_scope.order('first_name asc').paginate(page: params[:page])
               end
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

  def update_and_render_drafts
    if friend.update(friend_params)
      redirect_to community_friend_drafts_path(current_community, friend)
    else
      flash.now[:error] = 'Please fill in all required friend fields before managing documents.'
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

  def friend
    @friend ||= current_community.friends.find(params[:id])
  end

  def current_tab
    # TODO: See if params[:tab] is ever an empty string, otherwise can remove the presence
    params[:tab].presence || '#basic'
  end

  private

  def search
    Search.new(friend_index_scope, params[:query], params[:page])
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
      :visited_the_clinic,
      :criminal_conviction,
      :criminal_conviction_notes,
      :final_order_of_removal,
      :has_a_lawyer_for_detention,
      :detention_advocate_contact_name,
      :detention_advocate_contact_phone,
      :detention_advocate_contact_notes,
      :bonded_out_by_nsc,
      :bond_amount,
      :date_bonded_out,
      :bonded_out_by,
      :date_foia_request_submitted,
      :foia_request_notes,
      language_ids: [],
      user_ids: []
    ).merge(community_id: current_community.id, region_id: current_region.id)
  end

  def friend_index_scope
    scope = current_community.friends
    case params[:detained]
    when 'yes'
      scope = scope.detained
    when 'no'
      scope = scope.not_detained
    end
    scope
  end
end
