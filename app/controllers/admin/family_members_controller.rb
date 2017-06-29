class Admin::FamilyMembersController < AdminController

  def create
    if FamilyMember.create(family_member_params)
      respond_to do |format|
        format.js { render :file => 'admin/friends/family_members', locals: {friend: friend}}
      end
    else
    end
  end

  def friend
    Friend.find(family_member_params[:friend_id])
  end

  private
  def family_member_params
    params.require(:family_member).permit(
      :relationship,
      :friend_id,
      :relation_id
    )
  end
end