class Admin::JudgesController < AdminController
  before_action :set_judge, only: [:destroy]

  def index
    @judges = Judge.order('created_at desc').paginate(:page => params[:page])
  end

  def new
  end

  def create
  end

  def update
  end

  def destroy
    if @judge.destroy
      flash[:success] = 'Judge successfully removed' 
    else
      flash[:error] = 'Something went wrong :( the judge could not be removed' 
    end

    redirect_to admin_judges_path
  end

  private

  def set_judge
    @judge = Judge.find(params[:id])
  end
  
end
