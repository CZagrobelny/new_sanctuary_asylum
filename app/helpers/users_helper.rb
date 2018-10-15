module UsersHelper
  def user_search_filtered?
    params[:volunteer_type].present?
  end
end
