class Activity < ApplicationRecord
  ACCOMPANIMENT_ELIGIBLE_EVENTS = %w[master_calendar_hearing
                                     individual_hearing
                                     special_accompaniment
                                     check_in
                                     family_court
                                     bond_hearing
                                     fingerprinting].freeze

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
                                         foia_request_submitted].freeze
  EVENT_KEYS = ACCOMPANIMENT_ELIGIBLE_EVENTS + NON_ACCOMPANIMENT_ELIGIBLE_EVENTS
  EVENTS = EVENT_KEYS.map { |event| [event.titlecase, event] }

  belongs_to :friend
  belongs_to :region
  belongs_to :judge
  belongs_to :location
  has_many :accompaniments, -> { order(created_at: :asc) }, dependent: :destroy
  has_many :users, through: :accompaniments
  has_many :accompaniment_reports, dependent: :destroy

  validates :event, :occur_at, :friend_id, :region_id, presence: true

  scope :by_event, ->(events) {
    where(event: events)
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

  scope :by_dates, ->(beginning_of_week, end_of_week) {
    where('occur_at >= ? AND occur_at <= ? ',
          beginning_of_week,
          end_of_week)
  }

  scope :by_order, ->(order) {
    order(occur_at: order).group_by do |activity|
      activity.occur_at.to_date
    end
  }

  scope :for_week_confirmed_region, ->(events, region, beginning_of_week, end_of_week, result_order) {
                                      by_event(events)
                                        .by_region(region)
                                        .confirmed.by_dates(beginning_of_week,
                                                            end_of_week)
                                        .order(result_order)
                                    }

  scope :for_week_unconfirmed_region, ->(events, region, beginning_of_week, end_of_week, result_order) {
                                        by_event(events)
                                          .by_region(region)
                                          .confirmed.by_dates(beginning_of_week, end_of_week)
                                          .order(result_order)
                                      }

  User.roles.each do |role, _index|
    define_method "#{role}_accompaniments" do
      accompaniments.select do |accompaniment|
        accompaniment.user.role == role
      end
    end
  end

  def self.for_week(region:, beginning_of_week:, end_of_week:, order:, events:, confirmed: false)
    week = { dates: "#{beginning_of_week.strftime('%B %-d')} - #{(end_of_week - 2.days).strftime('%B %-d')}" }
    week[:activities] = if confirmed == true
                          Activity.for_week_confirmed_region(events,
                                                             region,
                                                             beginning_of_week,
                                                             end_of_week,
                                                             order)
                        else
                          Activity.for_week_unconfirmed_region(events,
                                                               region,
                                                               beginning_of_week,
                                                               end_of_week,
                                                               order)
                        end
    week
  end

  def self.upcoming_two_weeks(region:)
    if Date.today.cwday >= 5 && !Activity.remaining_this_week?
      week_1_beg = 1.weeks.from_now.beginning_of_week.beginning_of_day
      week_1_end = 1.weeks.from_now.end_of_week.end_of_day
      week_2_beg = 2.weeks.from_now.beginning_of_week.beginning_of_day
      week_2_end = 2.weeks.from_now.end_of_week.end_of_day
    else
      week_1_beg = Date.today.beginning_of_week.beginning_of_day
      week_1_end = Date.today.end_of_week.end_of_day
      week_2_beg = 1.weeks.from_now.beginning_of_week.beginning_of_day
      week_2_end = 1.weeks.from_now.end_of_week.end_of_day
    end

    activities = [Activity.for_week(beginning_of_week: week_1_beg,
                                    end_of_week: week_1_end,
                                    order: 'asc',
                                    events: ACCOMPANIMENT_ELIGIBLE_EVENTS,
                                    confirmed: true,
                                    region: region)]

    activities << Activity.for_week(beginning_of_week: week_2_beg,
                                    end_of_week: week_2_end,
                                    order: 'asc',
                                    events: ACCOMPANIMENT_ELIGIBLE_EVENTS,
                                    confirmed: true,
                                    region: region)
    activities
  end

  def self.current_month(events:, region:)
    activities = [Activity.for_week(beginning_of_week: Date.today.beginning_of_week,
                                    end_of_week: Date.today.end_of_week,
                                    order: 'asc',
                                    events: events,
                                    region: region)]
    (1..4).each do |i|
      beginning_of_week = i.weeks.from_now.beginning_of_week
      end_of_week = i.weeks.from_now.end_of_week
      activities << Activity.for_week(beginning_of_week: beginning_of_week,
                                      end_of_week: end_of_week,
                                      order: 'asc',
                                      events: events,
                                      region: region)
    end
    activities
  end

  def self.last_month(events:, region:)
    activities = []
    (1..5).each do |i|
      beginning_of_week = i.weeks.ago.beginning_of_week
      end_of_week = i.weeks.ago.end_of_week
      activities << Activity.for_week(beginning_of_week: beginning_of_week,
                                      end_of_week: end_of_week,
                                      order: 'desc',
                                      events: events,
                                      region: region)
    end
    activities
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
