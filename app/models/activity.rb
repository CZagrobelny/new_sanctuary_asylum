class Activity < ApplicationRecord
  belongs_to :friend
  belongs_to :region
  belongs_to :judge, optional: true
  belongs_to :location
  belongs_to :activity_type
  has_many :accompaniments, -> { order(created_at: :asc) }, dependent: :destroy
  has_many :users, through: :accompaniments
  has_many :accompaniment_reports, dependent: :destroy

  validates :activity_type_id, :friend_id, :region_id, presence: true
  validate :occur_at_OR_control_date_OR_tbd
  before_validation :ensure_occur_at_or_control_date_tbd

  scope :accompaniment_eligible, -> {
    joins(:activity_type).where(activity_types: { accompaniment_eligible: true })
  }

  scope :non_accompaniment_eligible, -> {
    joins(:activity_type).where(activity_types: { accompaniment_eligible: false })
  }

  scope :eoir_caller_editable, -> {
    joins(:activity_type).where(activity_types: { eoir_caller_editable: true })
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

  def last_edited_by_user
    User.find(last_edited_by) if last_edited_by
  end

  def accompaniment_leader_accompaniments
    accompaniments.select do |accompaniment|
      %w[accompaniment_leader eoir_caller].include?(accompaniment.user.role)
    end
  end

  def volunteer_accompaniments
    accompaniments.select do |accompaniment|
      User::ACCOMPANIMENT_ELIGIBLE_ROLES.include? accompaniment.user.role
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

  def occur_at_str
    if occur_at.present?
      occur_at.strftime("-- %I:%M %p, %A, %B %-d, %Y")
    elsif control_date.present?
      "-- Control Date: #{control_date.try(:strftime, "%B %-d, %Y")}"
    else
      '-- Date TBD'
    end
  end

  private
  def ensure_occur_at_or_control_date_tbd
    if occur_at.present?
      self.control_date = nil
      self.occur_at_tbd = false
    elsif control_date.present?
      self.occur_at_tbd = false
    end
  end

  def occur_at_OR_control_date_OR_tbd
    if !occur_at and !control_date and !occur_at_tbd
      errors.add(:base, "Activity needs either an occur at date, a control date, or TBD set to true")
    end
  end

end
