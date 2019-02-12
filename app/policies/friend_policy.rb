class FriendPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :friend

    def initialize(user, friend)
      @user = user
      @friend = friend
    end

    def resolve 
      if user.remote_clinic_lawyer?
        user.remote_clinic_friends.with_active_applications
      else
        user.friends.order('first_name asc')
      end
    end
  end

  def index? 
    user.admin? || user.volunteer?
  end
end
