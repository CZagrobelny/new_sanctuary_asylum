class Admin::FriendsController < AdminController
  def index
    if params[:query].present?
      query = '%' + params[:query].downcase + '%'
      @friends = Friend.where('lower(first_name) LIKE ? OR lower(last_name) LIKE ? OR a_number LIKE ?', query, query, query)
                    .order('created_at desc')
                    .paginate(:page => params[:page])
    else
      @friends = Friend.all.order('created_at desc').paginate(:page => params[:page])
    end
  end

  def new
    @friend = Friend.new
  end

  def edit
    @friend ||= Friend.find(params[:id])
    @current_tab = current_tab
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

  def destroy
    @friend = Friend.find(params[:id])
    if @friend.destroy
      flash[:success] = 'Friend record destroyed.'
      redirect_to admin_friends_path
    end
  end

  def update
    @friend = Friend.find(params[:id])
    @friend.update(friend_params)
    redirect_to edit_admin_friend_path(@friend, tab: current_tab)
  end

  def current_tab
    if params[:tab].present?
      params[:tab]
    else
      '#basic'
    end
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
      :lawyer_represented_by,
      :lawyer_referred_to,
      :language_ids => [],
      :user_ids => []
    )
  end
end
