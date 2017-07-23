class Admin::JudgesController < AdminController

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
  end
  
end
