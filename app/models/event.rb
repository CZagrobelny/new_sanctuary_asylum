class Event < ApplicationRecord
  belongs_to :community
  belongs_to :location
  has_many :friend_event_attendances, dependent: :destroy
  has_many :user_event_attendances, dependent: :destroy
  has_many :users, through: :user_event_attendances
  has_many :friends, through: :friend_event_attendances
  validates :date, :location_id, :title, :category, :community_id, presence: true

  CATEGORIES = %w[pro_se_clinic sijs_clinic asylum_workshop asylum_training accompaniment_training social].map { |category| [category.titlecase, category] }

  def user_attendances
    user_event_attendances.includes(:user).order('created_at desc')
  end

  def friend_attendances
    friend_event_attendances.includes(:friend).order('created_at desc')
  end

  def self.between_dates(start_date, end_date)
    where('date > ? AND date < ?', start_date, end_date)
  end

  def friend_attending?(friend)
    FriendEventAttendance.where(event_id: id, friend_id: friend.id).present?
  end

  def self.pro_se_clinics_at_dates(start_dates)
    events = []
    start_dates.each do |start_date|
      event = Event.where(category: 'pro_se_clinic')
                        .between_dates(start_date, start_date.end_of_day)
                        .first
      events << event if event
    end
    events
  end
end
