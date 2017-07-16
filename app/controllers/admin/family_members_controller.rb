class Admin::FamilyMembersController < AdminController

  def create
    family_member_constructor = FamilyMemberConstructor.new(family_member_constructor_params)
    if family_member_constructor.run
      respond_to do |format|
        format.js { render :file => 'admin/friends/family_members/list', locals: {friend: friend}}
      end
    else
      respond_to do |format|
        format.js { render :file => 'admin/friends/family_members/modal', locals: {friend: friend, family_member_constructor: family_member_constructor}}
      end
    end
  end

  def destroy_spousal_relationship
    spousal_relationship = SpousalRelationship.find(family_member_destroy_params[:family_member_id])
    @friend = Friend.find(family_member_destroy_params[:friend_id])
    if spousal_relationship.destroy
      respond_to do |format|
        format.js { render :file => 'admin/friends/family_members/list', locals: {friend: friend}}
      end
    end
  end

  def destroy_parent_child_relationship
    parent_child_relationship = ParentChildRelationship.find(family_member_destroy_params[:family_member_id])
    @friend = Friend.find(family_member_destroy_params[:friend_id])
    if parent_child_relationship.destroy
      respond_to do |format|
        format.js { render :file => 'admin/friends/family_members/list', locals: {friend: friend}}
      end
    end
  end

  def friend
    @friend ||= Friend.find(family_member_constructor_params[:friend_id])
  end

  private
  def family_member_constructor_params
    params.require(:family_member_constructor).permit(
      :relationship,
      :friend_id,
      :relation_id
    )
  end

  def family_member_destroy_params
    params.permit(
      :family_member_id,
      :friend_id
    )
  end
end
