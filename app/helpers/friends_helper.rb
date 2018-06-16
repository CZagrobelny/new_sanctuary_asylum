module FriendsHelper
  DATEPICKER_DATE_REGEXP = /\d{2}\/\d{2}\/\d{4}/

  def friend_search_filtered?
    {
      detained: 'yes',
      deadlines_ending_floor: DATEPICKER_DATE_REGEXP,
      deadlines_ending_ceiling: DATEPICKER_DATE_REGEXP
    }.any? do |key, value|
      if value.is_a?(Regexp)
        value.match(params[key])
      else
        params[key] == value
      end
    end
  end
end
