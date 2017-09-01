class Activity < ActiveRecord::Base
  EVENT_KEYS = ['check_in', 'master_calendar_hearing', 'individual_hearing', 'special_accompaniment', 'filing_asylum_application', 'filing_work_permit', 'detained']
  EVENTS = EVENT_KEYS.map{|event| [event.titlecase, event]}
  ACCOMPANIMENT_ELIGIBLE_EVENTS = ['master_calendar_hearing', 'individual_hearing', 'special_accompaniment', 'check_in']
  NON_ACCOMPANIMENT_ELIGIBLE_EVENTS = ['filing_asylum_application', 'filing_work_permit', 'detained']
  
  belongs_to :friend
  belongs_to :judge
  belongs_to :location
  has_many :accompaniments, dependent: :destroy
  has_many :volunteers, through: :accompaniments, source: :user
  has_many :accompaniment_reports, dependent: :destroy

  validates :event, :occur_at, :location_id, :friend_id, presence: true

  def self.for_week(beginning_of_week:, end_of_week:, order:, events:)
    { dates: "#{beginning_of_week.strftime('%B %-d')} - #{(end_of_week - 2.days).strftime('%B %-d')}", 

      activities: Activity.where(event: events)
                          .where('occur_at >= ? AND occur_at <= ? ', beginning_of_week, end_of_week)
                          .order("occur_at #{order}").group_by {|activity| activity.occur_at.to_date } }
  end

  def self.upcoming_two_weeks

    if Date.today.cwday == 5 && !Activity.remaining_this_week?
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

    activities = [ Activity.for_week(beginning_of_week: week_1_beg, 
                                     end_of_week: week_1_end, 
                                     order: 'asc', 
                                     events: ACCOMPANIMENT_ELIGIBLE_EVENTS) ]

    activities << Activity.for_week(beginning_of_week: week_2_beg, 
                                    end_of_week: week_2_end, 
                                    order: 'asc',  
                                    events: ACCOMPANIMENT_ELIGIBLE_EVENTS)
    activities
  end

  def self.current_month(events:)
    activities = [ Activity.for_week(beginning_of_week: Date.today.beginning_of_week, end_of_week: Date.today.end_of_week, order: 'asc', events: events) ]
    (1..4).each do |i|
      beginning_of_week = i.weeks.from_now.beginning_of_week
      end_of_week = i.weeks.from_now.end_of_week
      activities << Activity.for_week(beginning_of_week: beginning_of_week, end_of_week: end_of_week, order: 'asc', events: events)
    end
    activities
  end

  def self.last_month(events:)
    activities = []
    (1..5).each do |i|
      beginning_of_week = i.weeks.ago.beginning_of_week
      end_of_week = i.weeks.ago.end_of_week
      activities << Activity.for_week(beginning_of_week: beginning_of_week, end_of_week: end_of_week, order: 'desc', events: events)
    end
    activities
  end

  def self.remaining_this_week?
    Activity.where(event: ACCOMPANIMENT_ELIGIBLE_EVENTS).where('occur_at >= ? AND occur_at <= ? ', Time.now, Date.today.end_of_week.end_of_day).present?
  end
end
