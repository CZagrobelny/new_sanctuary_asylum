class Activity < ActiveRecord::Base
  enum event: [:check_in, :master_calendar_hearing, :individual_hearing, :filing_asylum_application, :filing_work_permit, :detained]
  
  belongs_to :friend
  belongs_to :judge
  belongs_to :location
  has_many :accompaniements, dependent: :destroy
  has_many :volunteers, through: :accompaniements, source: :user

  validates :event, :occur_at, :location_id, :friend_id, presence: true

  def self.upcoming
    where('occur_at >= ?', Date.today)
  end

  def self.past
    where('occur_at < ?', Date.today)
  end

  def self.current_week
    where('occur_at >= ? AND occur_at <= ? ', Date.today.beginning_of_week, Date.today.end_of_week).order('occur_at asc').group_by {|activity| activity.occur_at.to_date }
  end

  def self.next_week
    where('occur_at >= ? AND occur_at <= ? ', 1.week.from_now.beginning_of_week, 1.week.from_now.end_of_week).order('occur_at asc').group_by {|activity| activity.occur_at.to_date }
  end

  def self.accompaniement_eligible
    where(event: ['check_in', 'master_calendar_hearing', 'individual_hearing'])
  end

  def self.current_week_dates
    beginning_of_week = Date.today.beginning_of_week.strftime('%B %-d')
    end_of_week = (Date.today.end_of_week - 2.days).strftime('%B %-d')
    "#{beginning_of_week} - #{end_of_week}"
  end

  def self.next_week_dates
    beginning_of_week = 1.week.from_now.beginning_of_week.strftime('%B %-d')
    end_of_week = (1.week.from_now.end_of_week - 2.days).strftime('%B %-d')
    "#{beginning_of_week} - #{end_of_week}"
  end
end
