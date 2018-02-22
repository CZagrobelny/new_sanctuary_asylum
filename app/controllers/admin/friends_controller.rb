class Admin::FriendsController < AdminController
  def index
    @friends = if params[:query].present?
                 search.perform
               else
                 Friend.all.order('first_name asc').paginate(:page => params[:page])
               end
  end

  def new
    @friend = Friend.new
  end

  def edit
    @friend = friend
    @current_tab = current_tab
  end

  def create
    @friend = Friend.new(friend_params)
    if friend.save
      flash[:success] = 'Friend record saved.'
      redirect_to edit_admin_friend_path(@friend)
    else
      flash[:error] = 'Friend record not saved.'
      render :new
    end
  end

  def update
    if params['manage_asylum_drafts'].present?
      update_and_render_asylum_drafts
    elsif params['manage_sijs_drafts'].present?
      update_and_render_sijs_drafts
    else
      if friend.update(friend_params)
        flash[:success] = 'Friend record saved.'
        redirect_to edit_admin_friend_path(@friend, tab: current_tab)
      else
        flash[:error] = 'Friend record not saved.'
        render :edit
      end
    end
  end

  def update_and_render_asylum_drafts
    if friend.update(friend_params)
      redirect_to friend_asylum_application_drafts_path(friend)
    else
      flash[:error] = 'Please fill in all required friend fields before managing asylum application drafts.'
      render :edit
    end
  end

  def update_and_render_sijs_drafts
    if friend.update(friend_params)
      redirect_to friend_sijs_application_drafts_path(friend)
    else
      flash[:error] = 'Please fill in all required friend fields before managing asylum application drafts.'
      render :edit
    end
  end

  def destroy
    if friend.destroy
      flash[:success] = 'Friend record destroyed.'
    else
      flash[:error] = 'Friend record has a Draft and/or Activities. It cannot be deleted until these are removed.'
    end
    redirect_to admin_friends_path(query: params[:query])
  end

  def friend
    @friend ||= Friend.find(params[:id])
  end

  def current_tab
    if params[:tab].present?
      params[:tab]
    else
      '#basic'
    end
  end

  private

  def search 
    Search.new("friend", params[:query], params[:page])
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
      :language_ids => [],
      :user_ids => []
    )
  end
end
