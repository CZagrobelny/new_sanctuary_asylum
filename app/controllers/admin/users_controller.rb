class Admin::UsersController < AdminController
  before_action :require_admin, only: [:destroy, :edit, :update, :unlock]

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
      .limit(30)

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
      flash[:error] = 'This user cannot be deleted. To revoke access, change their permissions to "volunteer".'
    end
    redirect_to community_admin_users_path(current_community.slug, query: params[:query])
  end

  def edit
    @user = current_community.users.find(params[:id])
    @accompaniments = @user.accompaniments.includes(:activity).order("activities.occur_at")
  end

  def update
    @user = current_community.users.find(params[:id])
    ActiveRecord::Base.transaction do
      @user.update!(
        current_user.can_access_region?(current_region) ? user_params : user_params_excluding_role
      )
      if current_user.can_access_region?(current_region) && password_params.present?
        unless @user.reset_password(password_params[:password], password_params[:password])
          @user.errors.delete(:password)
          @user.errors.add(:password, 'does not meet minimum password requirements (see below).')
          raise
        end
      end
    end
    redirect_to community_admin_users_path(current_community.slug)
  rescue
    @accompaniments = @user.accompaniments.includes(:activity).order("activities.occur_at")
    render 'edit'
  end

  def unlock
    @user = current_community.users.find(params[:id])
    if @user.unlock_access!
      flash[:success] = 'User account unlocked!'
    else
      flash[:error] = 'There was an issue unlocking the user account.'
    end
    redirect_to edit_community_admin_user_path(current_community.slug, @user)
  end

  def select2_options
    @users = current_community.users
      .confirmed
      .where.not(role: [:admin, :remote_clinic_lawyer])
      .autocomplete_name(params[:q])
    results = { results: @users.map { |user| { id: user.id, text: user.name } } }

    respond_to do |format|
      format.json { render json: results }
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
      :agreed_to_data_entry_policies,
      :pledge_signed,
      :signed_guidelines,
      :attended_training,
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
      language_ids: [],
    )
  end

  def password_params
    compact_password_params = HashWithIndifferentAccess.new
    params.require(:user).permit(:password).each do |key, value|
      compact_password_params[key] = value.strip.empty? ? nil : value.strip
    end
    compact_password_params.compact
  end

  def user_index_scope
    current_community.users
  end
end
