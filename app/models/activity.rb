class Activity < ActiveRecord::Base
  enum event: [:check_in, :master_calendar_hearing, :individual_hearing, :filing_asylum_application, :filing_work_permit, :detained]
  
  belongs_to :friend
  belongs_to :judge
  belongs_to :location

  validates :event, :occur_at, :location_id, :friend_id, presence: true

  def self.upcoming
    where('occur_at >= ?', Date.today)
  end

  def self.past
    where('occur_at < ?', Date.today)
  end

end
