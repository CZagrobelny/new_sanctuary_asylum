module FriendsHelper
  DATEPICKER_DATE_REGEXP = /\d{2}\/\d{2}\/\d{4}/

  def friend_search_filtered?
    any_filter_check_boxes_checked? || date_params_valid?('deadlines_ending') || date_params_valid?('created_at')
  end

  def any_filter_check_boxes_checked?
    {
      detained: 'yes'
    }.any? do |key, value|
      params[key] == value
    end
  end

  def date_params_valid?(attribute)
    ["#{attribute}_ceiling".to_sym, "#{attribute}_floor".to_sym].all? { |key| DATEPICKER_DATE_REGEXP.match(params[key]) }
  end
end
