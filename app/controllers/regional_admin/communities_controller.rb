class RegionalAdmin::CommunitiesController < RegionalAdminController

  def index
    @communities = current_region.communities.order('name asc').paginate(:page => params[:page])
  end

  def new
    @community = current_region.communities.new
  end

  def edit
    @community = current_region.communities.find(params[:id])
  end

  def create
    @community = current_region.communities.new(community_params)

    if @community.save
      redirect_to regional_admin_region_communities_path(current_region, @community)
    else
      flash.now[:error] = "Something went wrong :("
      render 'new'
    end
  end

  def update
    @community = current_region.communities.where(slug: params[:id]).first
    if @community.update(community_params)
      redirect_to regional_admin_region_communities_path(current_region, @community)
    else
      flash.now[:error] = "Something went wrong :("
      render 'edit'
    end
  end

  private
  def community_params
    params.require(:community).permit(:name, :slug)
  end

end
