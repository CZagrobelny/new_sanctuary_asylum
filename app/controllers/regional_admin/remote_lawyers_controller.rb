class RegionalAdmin::RemoteLawyersController < AdminController
  before_action :set_lawyer, only: %i[edit update destroy]

  def index
    @remote_lawyers = User.remote_clinic_lawyer.order('last_name asc').paginate(page: params[:page])
  end

  def edit; end

  def update
    remote_lawyer_params.delete(:friend_ids)
    if @remote_lawyer.update(remote_lawyer_params.merge(user_friend_associations_params))
      redirect_to regional_admin_remote_lawyers_path
    else
      flash.now[:error] = 'Something went wrong :('
      render 'edit'
    end
  end

  def destroy
    return unless @remote_lawyer.destroy

    flash[:success] = 'Lawyer deleted.'
    redirect_to regional_admin_remote_lawyers_path
  end

  private

  def user_friend_associations_params
    persisted_friend_ids = @remote_lawyer.remote_clinic_friends.pluck(:id)
    friend_ids = remote_lawyer_params[:friend_ids]
    friend_ids_params = friend_ids ? friend_ids.map { |id| id.to_i if id.present? }.compact : []
    added_friend_ids = friend_ids_params - persisted_friend_ids
    removed_friend_ids = persisted_friend_ids - friend_ids_params

    user_friend_associations_attributes = []
    added_friend_ids.each do |friend_id|
      user_friend_associations_attributes << { friend_id: friend_id, user_id: @remote_lawyer.id, remote: true }
    end

    removed_friend_ids.each do |friend_id|
      id = UserFriendAssociation.where(friend_id: friend_id, user_id: @remote_lawyer.id, remote: true).first.id
      user_friend_associations_attributes << { id: id, _destroy: '1' }
    end
    { user_friend_associations_attributes: user_friend_associations_attributes }
  end

  def set_lawyer
    @remote_lawyer = User.find(params[:id])
  end

  def remote_lawyer_params
    params.require(:remote_lawyer).permit(
      :first_name,
      :last_name,
      :email,
      :phone,
      :role,
      :pledge_signed,
      :signed_guidelines,
      friend_ids: [],
      language_ids: []
    )
  end
end
