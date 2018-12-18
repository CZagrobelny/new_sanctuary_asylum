class Activity < ApplicationRecord
  ACCOMPANIMENT_ELIGIBLE_EVENTS = %w[master_calendar_hearing
                                     individual_hearing
                                     special_accompaniment
                                     check_in
                                     high_risk_ice_check_in
                                     family_court
                                     criminal_court
                                     bond_hearing
                                     fingerprinting
                                     border_crossing].freeze

  NON_ACCOMPANIMENT_ELIGIBLE_EVENTS = %w[filing_asylum_application
                                         asylum_granted
                                         filing_work_permit
                                         detained
                                         guardianship_requested
                                         sijs_special_findings_form_finished
                                         sijs_application_submitted
                                         sijs_granted
                                         sijs_denied
                                         change_of_venue_submitted
                                         foia_request_submitted
                                         foia_recieved
                                         I_130_sent
                                         stay_of_deportation_filed
                                         u_visa_filed
                                         habeas_corpus_filed].freeze

  EVENT_KEYS = ACCOMPANIMENT_ELIGIBLE_EVENTS + NON_ACCOMPANIMENT_ELIGIBLE_EVENTS
  EVENTS = EVENT_KEYS.map { |event| [event.titlecase, event] }

  belongs_to :friend
  belongs_to :region
  belongs_to :judge
  belongs_to :location
  belongs_to :activity_type
  has_many :accompaniments, -> { order(created_at: :asc) }, dependent: :destroy
  has_many :users, through: :accompaniments
  has_many :accompaniment_reports, dependent: :destroy

  validates :event, :occur_at, :friend_id, :region_id, presence: true

  scope :by_event, ->(events) {
    where(event: events)
  }

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

  scope :for_time_confirmed_region, ->(events, region, period_begin, period_end, result_order) {
                                      by_event(events)
                                        .by_region(region)
                                        .confirmed.by_dates(period_begin,
                                                            period_end)
                                        .by_order(result_order)
                                    }

  scope :for_time_confirmed, ->(events, period_begin, period_end) {
                               by_event(events)
                                 .confirmed.by_dates(period_begin,
                                                     period_end)
                                 .order(occur_at: 'asc')
                             }

  scope :for_time_unconfirmed, ->(events, period_begin, period_end) {
                                 by_event(events)
                                   .confirmed.by_dates(period_begin, period_end)
                                   .order(occur_at: 'desc')
                               }
  def accompaniment_limit_met?
    !!activity_type &&
    !!activity_type.cap &&
    volunteer_accompaniments.count >= activity_type.cap
  end

  def event=(event)
    self.activity_type = ActivityType.find_by(name: event)
    super(event)
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
    Activity.where(event: ACCOMPANIMENT_ELIGIBLE_EVENTS)
            .where('occur_at >= ? AND occur_at <= ? ',
                   Time.now,
                   Date.today.end_of_week.end_of_day).present?
  end

  def self.between_dates(start_date, end_date)
    where('occur_at > ? AND occur_at < ?', start_date, end_date)
  end

  def accompaniment_eligible?
    ACCOMPANIMENT_ELIGIBLE_EVENTS.include?(event)
  end
end
