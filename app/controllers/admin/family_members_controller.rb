class Admin::FamilyMembersController < AdminController

  def create
    FamilyMember.create(family_member_params)
  end

  private
  def family_member_params
    params.require(:family_member).permit(
      :relationship,
      :relation_id
    )
  end
end