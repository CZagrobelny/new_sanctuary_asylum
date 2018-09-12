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
      # TO DO, fix population of relation dropdown and set error on base
      render_modal
    end
  end

  def destroy
    @family_relationship ||= FamilyRelationship.find(params[:id])
    if @family_relationship.destroy
      # TO DO flash message
    else
      # TO DO flash message
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
      :reciprocal_relationship_id
    ).merge(friend_id: friend.id)
  end
end
