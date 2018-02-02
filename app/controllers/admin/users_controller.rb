class Admin::UsersController < AdminController
  def index
    @users = if params[:query].present? 
               search.perform
             else
               User.all.order('created_at desc').paginate(:page => params[:page])
             end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:success] = 'User record deleted.'
      redirect_to admin_users_path(query: params[:query])
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

  def search
    Search.new("user", params[:query], params[:page])
  end
  
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
