class RegionalAdmin::RegionsController < RegionalAdminController
  def index
    @regions = current_user.regions.order('name asc')
  end
end
