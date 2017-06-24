class Admin::UsersController < AdminController
  def index
    if params[:query].present?
      query = '%' + params[:query].downcase + '%'
      @users = User.where('lower(first_name) LIKE ? OR lower(last_name) LIKE ? OR lower(email) LIKE ?', query, query, query)
                    .order('created_at desc')
                    .paginate(:page => params[:page])
    else
      @users = User.all.order('created_at desc').paginate(:page => params[:page])
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:success] = 'User record saved.'
      redirect_to admin_users_path
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path
    else
      render 'edit'
    end
  end

  private
  def user_params
    params.require(:user).permit(
      :first_name, 
      :last_name, 
      :email, 
      :phone, 
      :volunteer_type,
      :role
    )
  end
end