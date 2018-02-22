class Event < ApplicationRecord
  belongs_to :location
  has_many :friend_event_attendances, dependent: :destroy
  has_many :user_event_attendances, dependent: :destroy
  has_many :users, through: :user_event_attendances
  has_many :friends, through: :friend_event_attendances
  validates :date, :location_id, :title, :category, presence: true

  CATEGORIES = ['asylum_workshop', 'asylum_training', 'accompaniment_training', 'social'].map{|category| [category.titlecase, category]}

  def user_attendances
    self.user_event_attendances.includes(:user).order('users.first_name asc')
  end
  
  def friend_attendances
    self.friend_event_attendances.includes(:friend).order('friends.first_name asc')
  end

  def self.between_dates(start_date, end_date)
    where('date > ? AND date < ?', start_date, end_date)
  end
end
