class Event < ActiveRecord::Base
  belongs_to :location
  has_many :friend_event_attendances, dependent: :destroy
  has_many :user_event_attendances, dependent: :destroy
  has_many :users, through: :user_event_attendances

  def user_attendances
  	self.user_event_attendances.includes(:user).order('users.first_name asc')
  end
end
