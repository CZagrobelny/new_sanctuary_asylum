class RegionalAdminController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  before_action :require_access_to_region
end
