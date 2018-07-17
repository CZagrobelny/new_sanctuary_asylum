module FriendsHelper
  DATEPICKER_DATE_REGEXP = /\d{2}\/\d{2}\/\d{4}/

  def friend_search_filtered?
    any_filter_check_boxes_checked? || filter_asylum_deadline_params_valid?
  end

  def any_filter_check_boxes_checked?
    {
      detained: 'yes'
    }.any? do |key, value|
      params[key] == value
    end
  end

  def filter_asylum_deadline_params_valid?
    [:deadlines_ending_ceiling, :deadlines_ending_floor].each do |key|
      return false unless DATEPICKER_DATE_REGEXP.match(params[key])
    end
    true
  end
end
