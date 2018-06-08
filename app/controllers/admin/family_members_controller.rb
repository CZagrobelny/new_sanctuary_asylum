class Admin::FamilyMembersController < AdminController
  def new
    @family_member_constructor = FamilyMemberConstructor.new
    render_modal
  end

  def create
    if family_member_constructor.run
      render_success
    else
      render_modal
    end
  end

  def destroy
    render_success if family_member.destroy
  end

  private

  def friend
    @friend ||= current_community.friends.find(params[:friend_id])
  end

  def family_member_constructor
    @family_member_constructor ||= FamilyMemberConstructor.new(family_member_constructor_params.merge(friend_id: friend.id))
  end

  def family_member
    case params[:type]
    when 'spousal'
      SpousalRelationship.find(params[:id])
    when 'parent_child'
      ParentChildRelationship.find(params[:id])
    when 'sibling'
      SiblingRelationship.find(params[:id])
    when 'partner'
      PartnerRelationship.find(params[:id])
    end
  end

  def family_member_constructor_params
    params.require(:family_member_constructor).permit(
      :relationship,
      :relation_id
    )
  end

  def render_success
    respond_to do |format|
      format.js { render file: 'admin/friends/family_members/list', locals: { friend: friend } }
    end
  end

  def render_modal
    respond_to do |format|
      format.js { render file: 'admin/friends/family_members/modal', locals: { friend: friend, family_member_constructor: family_member_constructor } }
    end
  end
end
