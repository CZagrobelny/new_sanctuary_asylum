class Admin::UsersController < AdminController
  def index
    @users = if params[:query].present?
               search.perform
             else
               current_community.users.all.order('created_at desc').paginate(:page => params[:page])
             end
  end

  def destroy
    @user = current_community.users.find(params[:id])
    if @user.destroy
      flash[:success] = 'User record deleted.'
      redirect_to community_admin_users_path(current_community, query: params[:query])
    end
  end

  def edit
    @user = current_community.users.find(params[:id])
  end

  def update
    @user = current_community.users.find(params[:id])
    if @user.update(user_params)
      redirect_to community_admin_users_path(current_community)
    else
      render 'edit'
    end
  end

  private

  def search
    Search.new(User, params[:query], params[:page])
  end

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :phone,
      :volunteer_type,
      :role,
      :signed_guidelines
    )
  end
end
