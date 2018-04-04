module FriendsHelper
  def friend_search_filtered?
    {
      detained: 'yes'
    }.any? do |key, value|
      params[key] == value
    end
  end
end
