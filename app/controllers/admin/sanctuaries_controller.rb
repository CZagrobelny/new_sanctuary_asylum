class Admin::SanctuariesController < ApplicationController
  before_action :set_sanctuary, only: [:edit, :update]

  def index
    @sanctuaries = Sanctuary.order('name ASC').paginate(page: params[:page])
  end

  def new
    @sanctuary = Sanctuary.new
  end

  def create
    @sanctuary = Sanctuary.new(sanctuary_params)

    if @sanctuary.save
      redirect_to admin_sanctuaries_path
    else
      flash.now[:error] = "Something went wrong :("
      render 'new'
    end
  end

  def edit
    # Render
  end

  def update
    if @sanctuary.update(sanctuary_params)
      redirect_to admin_sanctuaries_path
    else
      flash[:error] = "Something went wrong :("
      render 'edit'
    end
  end

private

  def set_sanctuary
    @sanctuary = Sanctuary.find(params[:id])
  end

  def sanctuary_params
    params.require(:sanctuary).permit(:name, :address, :city, :state, :zip_code, :leader_name, :leader_phone_number, :leader_email)
  end
end
