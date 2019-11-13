class Admin::JudgesController < AdminController
  before_action :require_primary_community
  before_action :set_judge, only: %i[edit update hide]

  def index
    @judges = current_region.judges.order('last_name asc').paginate(page: params[:page])
  end

  def new
    @judge = current_region.judges.new
  end

  def edit; end

  def create
    @judge = current_region.judges.new(judge_params)

    if @judge.save
      redirect_to community_admin_judges_path(current_community.slug)
    else
      flash.now[:error] = 'Something went wrong :('
      render 'new'
    end
  end

  def update
    if @judge.update(judge_params)
      redirect_to community_admin_judges_path(current_community.slug)
    else
      flash.now[:error] = 'Something went wrong :('
      render 'edit'
    end
  end

  def hide
    if @judge.update(hidden: true)
      redirect_to community_admin_judges_path(current_community.slug)
    else
      flash.now[:error] = 'Something went wrong :('
      render 'edit'
    end
  end

  private

  def set_judge
    @judge = current_region.judges.find(params[:id])
  end

  def judge_params
    params.require(:judge).permit(:first_name, :last_name, :hidden)
  end
end
