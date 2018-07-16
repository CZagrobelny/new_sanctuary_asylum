class Admin::UsersController < AdminController
  def index
    @users = if params[:query].present?
               search.perform
             else
               user_index_scope.order('created_at desc').paginate(page: params[:page])
             end
  end

  def destroy
    @user = current_community.users.find(params[:id])
    return unless @user.destroy
    flash[:success] = 'User record deleted.'
    redirect_to community_admin_users_path(current_community.slug, query: params[:query])
  end

  def edit
    @user = current_community.users.find(params[:id])
  end

  def update
    @user = current_community.users.find(params[:id])
    if @user.update(user_params)
      redirect_to community_admin_users_path(current_community.slug)
    else
      render 'edit'
    end
  end

  private

  def search
    Search.new(user_index_scope, params[:query], params[:page])
  end

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :phone,
      :volunteer_type,
      :role,
      :signed_guidelines,
      :remote_clinic_lawyer
    )
  end

  def user_index_scope
    scope = current_community.users
    scope = scope.for_volunteer_type(params[:volunteer_type]) if params[:volunteer_type].present?
    scope
  end
end
