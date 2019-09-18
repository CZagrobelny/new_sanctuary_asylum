class Admin::UsersController < AdminController
  def index
    @filterrific = initialize_filterrific(User,
                                          params[:filterrific],
                                          persistence_id: false)

    @filterrific_role = initialize_filterrific(User,
                                          params[:filterrific_role],
                                          select_options: {
                                            filter_role: role_options
                                          },
                                          persistence_id: false)


    @users = current_community.users
      .order('created_at DESC')
      .filterrific_find(@filterrific)
      .paginate(page: params[:page])

    respond_to do |format|
      format.html
      format.js
    end

  # Recover from invalid param sets, e.g., when a filter refers to the
  # database id of a record that doesn’t exist any more.
  # In this case we reset filterrific and discard all filter params.
  rescue ActiveRecord::RecordNotFound => e
    # There is an issue with the persisted param_set. Reset it.
    puts "Had to reset filterrific params: #{e.message}"
    redirect_to(reset_filterrific_url(format: :html)) && return
  end

  def destroy
    @user = current_community.users.find(params[:id])
    if @user.destroy
      flash[:success] = 'User record deleted.'
    else
      flash[:error] = 'There was an issue deleting the user.'
    end
    redirect_to community_admin_users_path(current_community.slug, query: params[:query])
  end

  def edit
    @user = current_community.users.find(params[:id])
    @accompaniments = @user.accompaniments.includes(:activity).order("activities.occur_at")
  end

  def update
    @user = current_community.users.find(params[:id])

    if @user.update(current_user.admin? ? user_params : user_params_excluding_role)
      redirect_to community_admin_users_path(current_community.slug)
    else
      render 'edit'
    end
  end

  private

  def role_options
    User.roles.keys.map do |role_type|
      [role_type.humanize, role_type]
    end
  end

  def search
    Search.new(user_index_scope, params[:query], params[:page])
  end

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :phone,
      :role,
      :pledge_signed,
      :signed_guidelines,
      :attended_training,
      :remote_clinic_lawyer,
      language_ids: [],
    )
  end

  def user_params_excluding_role
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :phone,
      :pledge_signed,
      :signed_guidelines,
      :attended_training,
      :remote_clinic_lawyer,
      language_ids: [],
    )
  end

  def user_index_scope
    current_community.users
  end
end
