class Admin::FamilyRelationshipsController < AdminController
  def new
    @family_relationship = FamilyRelationship.new(friend_id: friend.id)
    render_modal
  end

  def create
    @family_relationship = FamilyRelationship.create(family_relationship_params)
    if @family_relationship.persisted?
      render_list
    else
      render_modal
    end
  end

  def destroy
    @family_relationship ||= FamilyRelationship.find(params[:id])
    unless @family_relationship.destroy
      flash[:error] = 'There was an issue removing this family relationship.'
    end
    render_list
  end

  private

  def render_modal
    respond_to do |format|
      format.js do
        render file: 'admin/friends/family_relationships/modal',
          locals: { friend: friend, family_relationship: @family_relationship }
      end
    end
  end

  def render_list
    respond_to do |format|
      format.js do
        render file: 'admin/friends/family_relationships/list', locals: { friend: friend }
      end
    end
  end

  def friend
    @friend ||= current_community.friends.find(params[:friend_id])
  end

  def family_relationship_params
    params.require(:family_relationship).permit(
      :relation_id,
      :relationship_type,
    ).merge(friend_id: friend.id)
  end
end
