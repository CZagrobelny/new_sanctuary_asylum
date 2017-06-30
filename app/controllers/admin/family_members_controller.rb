class Admin::FamilyMembersController < AdminController

  def create
    family_member_constructor = FamilyMemberConstructor.new(family_member_constructor_params)
    if family_member_constructor.run
      respond_to do |format|
        format.js { render :file => 'admin/friends/family_members', locals: {friend: friend}}
      end
    else
      respond_to do |format|
        format.js { render :file => 'admin/friends/family_modal', locals: {friend: friend, family_member_constructor: family_member_constructor}}
      end
    end
  end

  def friend
    Friend.find(family_member_constructor_params[:friend_id])
  end

  private
  def family_member_constructor_params
    params.require(:family_member_constructor).permit(
      :relationship,
      :friend_id,
      :relation_id
    )
  end
end