class Activity < ApplicationRecord
  belongs_to :friend
  belongs_to :region
  belongs_to :judge
  belongs_to :location
  belongs_to :activity_type
  has_many :accompaniments, -> { order(created_at: :asc) }, dependent: :destroy
  has_many :users, through: :accompaniments
  has_many :accompaniment_reports, dependent: :destroy

  validates :activity_type_id, :occur_at, :friend_id, :region_id, presence: true

  scope :accompaniment_eligible, -> {
    joins(:activity_type).where(activity_types: { accompaniment_eligible: true })
  }

  scope :non_accompaniment_eligible, -> {
    joins(:activity_type).where(activity_types: { accompaniment_eligible: false })
  }

  scope :by_region, ->(region) {
    where(region_id: region.id)
  }

  scope :confirmed, -> {
    where(confirmed: true)
  }

  scope :unconfirmed, -> {
    where(confirmed: false)
  }

  scope :by_dates, ->(period_begin, period_end) {
    where('occur_at >= ? AND occur_at <= ? ',
          period_begin,
          period_end)
  }

  scope :by_order, ->(order) {
    order(occur_at: order).group_by do |activity|
      activity.occur_at.to_date
    end
  }

  scope :for_time_confirmed, ->(period_begin, period_end) {
                               accompaniment_eligible
                                 .confirmed.by_dates(period_begin, period_end)
                                 .order(occur_at: 'asc')
                             }

  scope :for_time_unconfirmed, ->(period_begin, period_end) {
                                 accompaniment_eligibile
                                   .confirmed.by_dates(period_begin, period_end)
                                   .order(occur_at: 'desc')
                               }

  def accompaniment_limit_met?
    !!activity_type &&
      !!activity_type.cap &&
      volunteer_accompaniments.count >= activity_type.cap
  end

  def start_time
    occur_at
  end

  User.roles.each do |role, _index|
    define_method "#{role}_accompaniments" do
      accompaniments.select do |accompaniment|
        accompaniment.user.role == role
      end
    end
  end

  def self.remaining_this_week?
    Activity.accompaniment_eligible
            .confirmed
            .where('occur_at >= ? AND occur_at <= ? ',
                   Time.now,
                   Date.today.end_of_week.end_of_day).present?
  end

  def self.between_dates(start_date, end_date)
    where('occur_at > ? AND occur_at < ?', start_date, end_date)
  end

  def accompaniment_eligible?
    activity_type.accompaniment_eligible
  end
end
