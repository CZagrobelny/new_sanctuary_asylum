class Admin::LawyersController < AdminController
  before_action :set_lawyer, only: [:edit, :destroy, :update]

  def index
    @lawyers = Lawyer.order('created_at desc').paginate(:page => params[:page])
  end

  def new
    @lawyer = Lawyer.new
  end

  def edit
  end

  def create
    @lawyer = Lawyer.new(lawyer_params)
    
    if @lawyer.save
      redirect_to admin_lawyers_path
    else
      flash[:error] = "Something went wrong :("
      render 'new'
    end
  end

  def update
    @lawyer.update(lawyer_params)
    redirect_to admin_lawyers_path
  end

  private

  def set_lawyer
    @lawyer = Lawyer.find(params[:id])
  end

  def lawyer_params
    params.require(:lawyer).permit(:first_name, :last_name)
  end
  
end
