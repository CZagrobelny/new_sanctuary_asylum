class Admin::FriendsController < AdminController
  def index
    @friends = if params[:query].present?
                 search.perform
               else
                 Friend.all.order('created_at desc').paginate(:page => params[:page])
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
      flash.now[:error] = 'Friend record not saved.'
      render :new
    end
  end

  def update
    if friend.update(friend_params)
      flash[:success] = 'Friend record saved.'
      redirect_to edit_admin_friend_path(@friend, tab: current_tab)
    else
      flash.now[:error] = 'Friend record not saved.'
      render :edit
    end
  end

  def destroy
    if friend.destroy
      flash[:success] = 'Friend record destroyed.'
      redirect_to admin_friends_path
    else
      flash[:success] = 'Friend record not destroyed.'
      redirect_to admin_friends_path
    end
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
      :country_id,
      :lawyer_represented_by,
      :lawyer_referred_to,
      :language_ids => [],
      :user_ids => []
    )
  end
end
