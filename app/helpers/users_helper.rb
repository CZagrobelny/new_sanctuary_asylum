module UsersHelper
  def user_search_filtered?
    params[:volunteer_type].present?
  end

  def user_volunteer_type_options
    User.volunteer_types.keys.map { |volunteer_type| [volunteer_type.humanize, volunteer_type] }
  end
end
