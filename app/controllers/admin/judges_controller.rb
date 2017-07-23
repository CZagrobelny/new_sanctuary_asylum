class Admin::JudgesController < AdminController
  before_action :set_judge, only: [:destroy]

  def index
    @judges = Judge.order('created_at desc').paginate(:page => params[:page])
  end

  def new
    @judge = Judge.new
  end

  def create
    @judge = Judge.new(judge_params)
    
    if @judge.save
      redirect_to admin_judges_path
    else
      flash[:error] = "Something went wrong :("
      render 'new'
    end
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

  def judge_params
    params.require(:judge).permit(:first_name, :last_name)
  end
  
end
