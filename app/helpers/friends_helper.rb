module FriendsHelper
  DATE_REGEXP = /\d{4}\-\d{2}-\d{2}/

  def friend_search_filtered?
    {
      detained: 'yes',
      deadline_start_date: DATE_REGEXP,
      deadline_end_date: DATE_REGEXP
    }.any? do |key, value|
      if value.is_a?(Regexp)
        value.match(params[key])
      else
        params[key] == value
      end
    end
  end
end
