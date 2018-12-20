class Friend < ApplicationRecord
  include PgSearch

  enum ethnicity: %i[white black hispanic asian south_asian caribbean indigenous other]
  enum gender: %i[male female awesome]

  STATUSES = %w[in_deportation_proceedings
                not_in_deportation_proceedings
                asylum_reciepient
                asylum_application_denied
                legal_permanent_resident
                in_detention green_card_holder].map do |status|
    [status.titlecase,
     status]
  end
  ASYLUM_STATUSES = %w[not_eligible
                       eligible
                       application_started
                       application_completed
                       application_submitted
                       affirmative_application_referred_to_immigration_judge
                       granted denied].map { |status| [status.titlecase, status] }
  WORK_AUTHORIZATION_STATUSES = %w[not_eligible
                                   eligible
                                   application_started
                                   application_completed
                                   application_submitted
                                   granted denied].map { |status| [status.titlecase, status] }
  SIJS_STATUSES = %w[qualifies
                     in_progress
                     submitted
                     approved
                     denied].map { |status| [status.titlecase, status] }

  BORDER_CROSSING_STATUSES = %w[ready_to_cross successfully_crossed].map { |status| [status.titlecase, status] }

  ASYLUM_APPLICATION_DEADLINE = 1.year

  belongs_to :community
  belongs_to :region
  has_many :friend_languages, dependent: :destroy
  has_many :languages, through: :friend_languages
  has_many :activities, dependent: :restrict_with_error
  has_many :detentions, dependent: :destroy
  has_many :user_friend_associations, dependent: :destroy
  has_many :users, through: :user_friend_associations
  has_many :drafts, dependent: :restrict_with_error
  has_many :applications
  has_many :friend_event_attendances, dependent: :destroy
  has_many :events, through: :friend_event_attendances
  has_many :family_relationships, dependent: :destroy
  has_many :family_members, through: :family_relationships, source: 'relation'
  has_many :releases, dependent: :destroy

  accepts_nested_attributes_for :user_friend_associations, allow_destroy: true

  validates :first_name, :last_name, :community_id, :region_id, presence: true
  validates :zip_code, length: { is: 5 }, allow_blank: true, numericality: true
  validates :a_number, presence: { if: :a_number_available? }, numericality: { if: :a_number_available? }
  validates :a_number, length: { minimum: 8, maximum: 9 }, if: :a_number_available?
  validates_uniqueness_of :a_number, if: :a_number_available?

  scope :detained, -> { where(status: 'in_detention') }

  scope :with_active_applications, -> {
    joins(:applications)
      .distinct
      .where(applications: { status: %i[in_review changes_requested approved] })
  }

  def volunteers_with_access
    users.where(user_friend_associations: { remote: false })
  end

  def remote_clinic_lawyers
    users.where(user_friend_associations: { remote: true })
  end

  pg_search_scope :filter_first_name, against: :first_name,
                                      using: {tsearch: {:prefix => true}}

  pg_search_scope :filter_last_name, against: :last_name,
                                     using: {tsearch: {:prefix => true}}

  scope :filter_a_number, ->(number) {
    where(a_number: number)
  }

  scope :filter_border_queue_number, ->(number) {
    where(border_queue_number: number)
  }

  scope :filter_detained, ->(detained) {
    where(status: 'in_detention') if detained == 1
  }

  scope :filter_asylum_application_deadline_ending_after, ->(date) {
    # if the date - 1.year is smaller than the date_of_entry
    where('date_of_entry >= ?', string_to_beginning_of_date(date) - ASYLUM_APPLICATION_DEADLINE)
  }

  scope :filter_asylum_application_deadline_ending_before, ->(date) {
    # if the date - 1.year is greater than the date_of_entry
    where('date_of_entry <= ?', string_to_end_of_date(date) - ASYLUM_APPLICATION_DEADLINE)
  }

  scope :filter_created_after, ->(date) {
    where('created_at >= ?', string_to_beginning_of_date(date))
  }

  scope :filter_created_before, ->(date) {
    where('created_at <= ?', string_to_end_of_date(date))
  }

  filterrific(default_filter_params: {},
              available_filters: %i[filter_first_name
                                    filter_last_name
                                    filter_a_number
                                    filter_detained
                                    filter_asylum_application_deadline_ending_after
                                    filter_asylum_application_deadline_ending_before
                                    filter_created_after
                                    filter_created_before
                                    filter_border_queue_number])

  def name
    "#{first_name} #{last_name}"
  end

  def ethnicity
    other? ? self[:other_ethnicity] : self[:ethnicity]
  end

  def grouped_drafts
    applications.map do |application|
      {
        name: application.category,
        drafts: application.drafts.order('created_at desc'),
        application: application
      }
    end
  end

  def detained?
    status == 'in_detention'
  end

  def self.string_to_beginning_of_date(date)
    date.to_str.to_date.beginning_of_day
  end

  def self.string_to_end_of_date(date)
    date.to_str.to_date.end_of_day
  end

  private

  def a_number_available?
    no_a_number == false
  end
end
