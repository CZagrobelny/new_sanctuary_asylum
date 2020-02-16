class EoirCaller::SearchController < EoirCallerController
  def index
    if params.dig(:friend, :a_number)
      @friend = current_community.friends.find_by_a_number(params.dig(:friend, :a_number))
    end
  end
end
