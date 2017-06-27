class Admin::FamilyMembersController < AdminController

  def create
    family_member = FamilyMember.create(family_member_params)
    respond_to do |format|
      format.js { render :file => 'admin/family/family_members', locals: {friend: friend}}
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