class Friend < ApplicationRecord
  include PgSearch::Model

  enum ethnicity: %i[white black hispanic asian south_asian caribbean indigenous other]
  enum gender: %i[male female awesome]

  STATUSES = %w[in_deportation_proceedings
                not_in_deportation_proceedings
                asylum_reciepient
                asylum_application_denied
                withholding_of_removal_granted
                cat_granted
                legal_permanent_resident
                in_detention
                deported
              ].map do |status|
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

  EOIR_CASE_STATUSES = %w[case_pending
                          case_information_not_available
                          no_case_found_for_a_number
                          appeal_pending
                          motion_to_reopen_pending
                          voluntary_departure
                          terminated_proceedings
                          immigration_judge_ordered_removal
                          application_granted
                          application_denied
                          administrative_decision_issued
                        ].map { |status| [status.titlecase, status] }

  CLINIC_PLANS = %w[i589
                    individual_hearing
                    motion_to_reopen
                    appeal
                    osup_rfi
                    consultation
                    foia
                    change_of_venue
                    work_permit].map{ |plan| [plan.titlecase, plan] }

  ASYLUM_APPLICATION_DEADLINE = 1.year

  belongs_to :community
  belongs_to :region
  has_many :friend_languages, dependent: :destroy
  has_many :languages, through: :friend_languages
  has_many :activities, dependent: :restrict_with_error
  has_many :accompaniment_reports, dependent: :restrict_with_error
  has_many :detentions, dependent: :destroy
  has_many :ankle_monitors, dependent: :destroy
  has_many :user_friend_associations, dependent: :destroy
  has_many :users, through: :user_friend_associations
  has_many :drafts, dependent: :restrict_with_error
  has_many :applications
  has_many :friend_event_attendances, dependent: :destroy
  has_many :events, through: :friend_event_attendances
  has_many :friend_cohort_assignments, dependent: :destroy
  has_many :cohorts, through: :friend_cohort_assignments
  has_many :family_relationships, dependent: :destroy
  has_many :family_members, through: :family_relationships, source: 'relation'
  has_many :friend_social_work_referral_categories, dependent: :destroy
  has_many :social_work_referral_categories, through: :friend_social_work_referral_categories
  has_many :friend_notes, dependent: :destroy
  has_one :country
  has_many :remote_review_actions, dependent: :destroy

  accepts_nested_attributes_for :user_friend_associations, allow_destroy: true

  validates :first_name, :last_name, :community_id, :region_id, presence: true
  validates :zip_code, length: { is: 5 }, allow_blank: true, numericality: true
  validates :a_number, presence: { if: :a_number_available? }, numericality: { if: :a_number_available? }
  validates :a_number, length: { minimum: 8, maximum: 9 }, if: :a_number_available?
  validates_uniqueness_of :a_number, if: :a_number_available?
  validates :gender, presence: true, on: :create
  validates :clinic_plan, inclusion: {in: CLINIC_PLANS.map(&:last)}, allow_blank: true

  scope :detained, -> { where(status: 'in_detention') }

  scope :with_active_applications, -> {
    joins(:applications)
      .distinct
      .where(applications: { status: %i[review_requested review_added approved] })
  }

  pg_search_scope :autocomplete_name,
    against: [:first_name, :last_name],
    using: {
      tsearch: { prefix: true }
    }

  def volunteers_with_access
    users.where(user_friend_associations: { remote: false })
  end

  def remote_clinic_lawyers
    users.where(user_friend_associations: { remote: true })
  end


  pg_search_scope :filter_first_name, against: :first_name,
                                      using: { tsearch: { prefix: true } }

  pg_search_scope :filter_last_name, against: :last_name,
                                     using: { tsearch: { prefix: true } }

  scope :filter_a_number, ->(number) {
    where(a_number: number)
  }

  scope :filter_id, ->(id) {
    where(id: id)
  }

  scope :filter_detained, ->(detained) {
    where(status: 'in_detention') if detained == 1
  }

  scope :filter_invited_to_speak_to_a_lawyer, ->(invited_to_speak_to_a_lawyer) {
    where(invited_to_speak_to_a_lawyer: true) if invited_to_speak_to_a_lawyer == 1
  }

  scope :filter_famu_docket, ->(famu_docket) {
    where(famu_docket: true) if famu_docket == 1
  }

  scope :filter_no_record_in_eoir, ->(no_record_in_eoir) {
    where(no_record_in_eoir: true) if no_record_in_eoir == 1
  }

  scope :filter_order_of_supervision, ->(order_of_supervision) {
    where(order_of_supervision: true) if order_of_supervision == 1
  }

  scope :filter_has_a_lawyer, ->(has_a_lawyer) {
    where(has_a_lawyer: true) if has_a_lawyer == 1
  }

  scope :filter_must_be_seen_by_after, ->(date) {
    where('must_be_seen_by >= ?', string_to_beginning_of_date(date))
  }

  scope :filter_must_be_seen_by_before, ->(date) {
    where('must_be_seen_by <= ?', string_to_end_of_date(date))
  }

  scope :filter_asylum_application_deadline_ending_after, ->(date) {
    # if the date - 1.year is smaller than the date_of_entry
    where('date_of_entry >= ?', string_to_beginning_of_date(date) - ASYLUM_APPLICATION_DEADLINE)
  }

  scope :filter_asylum_application_deadline_ending_before, ->(date) {
    # if the date - 1.year is greater than the date_of_entry
    where('date_of_entry <= ?', string_to_end_of_date(date) - ASYLUM_APPLICATION_DEADLINE)
  }

  scope :filter_judge_imposed_deadline_ending_after, ->(date) {
    where('judge_imposed_i589_deadline > ?', string_to_beginning_of_date(date))
  }

  scope :filter_judge_imposed_deadline_ending_before, ->(date) {
    where('judge_imposed_i589_deadline <= ?', string_to_beginning_of_date(date))
  }

  scope :filter_created_after, ->(date) {
    where('created_at >= ?', string_to_beginning_of_date(date))
  }

  scope :filter_created_before, ->(date) {
    where('created_at <= ?', string_to_end_of_date(date))
  }

  scope :filter_phone_number, ->(phone) {
    return nil if phone.blank?

    # cast to string (if query just "123", would get integer)
    # lowercase & normalize . () - + and space out
    number_chunks = phone.to_s.downcase.split(/[\s+\-\(\)\.\+]/)

    # make this a wildcard search by surrounding with %
    number_chunks = number_chunks.map { |chunk|
      "%" + chunk + "%"
    }

    # search for each chunk separately
    where(
      number_chunks.map { |_term|
        "(LOWER(friends.phone) LIKE ?)"
      }.join(" AND "),
      *number_chunks.flatten,
    )
  }

  pg_search_scope :filter_notes,
    associated_against: { friend_notes: :note },
    using: {
      tsearch: { dictionary: "english" }
    }

  scope :sorted_by, ->(sort_option) {
    # extract the sort direction from the param value.
    direction = sort_option =~ /desc$/ ? 'desc' : 'asc'
    case sort_option.to_s
    when /^created_at_/
      # Simple sort on the created_at column.
      order("friends.created_at #{direction}")
    when /^intake_date_/
      where('intake_date IS NOT NULL').order("friends.intake_date #{direction}")
    when /^must_be_seen_by_/
      where('must_be_seen_by IS NOT NULL').order("friends.must_be_seen_by #{direction}")
    when /^date_of_entry/
      where('date_of_entry IS NOT NULL').order("friends.date_of_entry #{direction}")
    when /^last_name/
      order("friends.last_name #{direction}")
    else
      raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
    end
  }

  scope :activity_type, ->(activity_type_ids) {
    joins(:activities)
      .where(activities: { activity_type_id: activity_type_ids })
  }

  scope :filter_activity_start_date, ->(time) {
    joins(:activities)
      .where('activities.occur_at >= ?', Date.strptime(time, '%m/%d/%Y').beginning_of_day)
  }

  scope :filter_activity_end_date, ->(time) {
    joins(:activities)
      .where('activities.occur_at <= ?', Date.strptime(time, '%m/%d/%Y').end_of_day)
  }

  scope :activity_judge, ->(activity_judge_ids) {
    joins(:activities)
      .where(activities: { judge: activity_judge_ids })
  }

  scope :activity_location, ->(activity_locations) {
    joins(:activities)
      .where(activities: { location: activity_locations })
  }

  scope :filter_activity_tbd_or_control_date, ->(occur_at_tbd) {
    if occur_at_tbd == 1
      joins(:activities)
        .distinct
        .where('activities.occur_at_tbd = true or activities.control_date is not null')
    end
  }

  scope :country_of_origin, ->(country_ids) {
    unless country_ids.reject! { |id| id.try(:strip) == '' || id.nil? }.empty?
      where(country_id: country_ids)
    end
  }


  filterrific(default_filter_params: {},
              available_filters: %i[filter_id
                                    filter_first_name
                                    filter_last_name
                                    filter_a_number
                                    filter_detained
                                    filter_activity_tbd_or_control_date
                                    filter_invited_to_speak_to_a_lawyer
                                    filter_famu_docket
                                    filter_must_be_seen_by_after
                                    filter_must_be_seen_by_before
                                    filter_asylum_application_deadline_ending_after
                                    filter_asylum_application_deadline_ending_before
                                    filter_created_after
                                    filter_created_before
                                    filter_judge_imposed_deadline_ending_after
                                    filter_judge_imposed_deadline_ending_before
                                    filter_phone_number
                                    filter_notes
                                    filter_activity_start_date
                                    filter_activity_end_date
                                    sorted_by
                                    activity_type
                                    activity_judge
                                    activity_location
                                    filter_no_record_in_eoir
                                    filter_order_of_supervision
                                    filter_has_a_lawyer
                                    country_of_origin
                                  ])

  # This method provides select options for the `activity_type` filter select input
  def self.options_for_activity_type
    ActivityType.all.map do |type|
      [type.name.humanize, type.id]
    end
  end

  # This method provides select options for the `activity_judge` filter select input
  def self.options_for_activity_judge(current_region)
    current_region.judges.active.map do |judge|
      [judge.name, judge.id]
    end
  end

  # This method provides select options for the `activity_location` filter select input
  def self.options_for_activity_location(current_region)
    current_region.locations.order('name').map do |location|
      [location.name, location.id]
    end
  end

  # This method provides select options for the `country_of_origin` filter select input
  def self.options_for_country_of_origin
    Country.all.map do |type|
      [type.name.titlecase, type.id]
    end
  end

  # This method provides select options for the `sorted_by` filter select input.
  def self.options_for_sorted_by
    [
      %w[Newest created_at_desc],
      %w[Oldest created_at_asc],
      ['Intake Date (Ascending)', 'intake_date_asc'],
      ['Intake Date (Descending)', 'intake_date_desc'],
      ['Must Be Seen By (Soonest)', 'must_be_seen_by_asc'],
      ['Date of Entry (Ascending)', 'date_of_entry_asc'],
      ['Date of Entry (Descending)', 'date_of_entry_desc'],
      ['Last Name (Ascending)', 'last_name_asc'],
      ['Last Name (Descending)', 'last_name_desc'],
    ]
  end

  # This method provides select options for the `application_status` filter select input.
  def self.options_for_application_status_filter_by
    [
      %w[All all_active],
      ['Review Requested', 'review_requested'],
      ['Review Added', 'review_added'],
      %w[Approved approved]
    ]
  end

  def name
    "#{first_name} #{last_name}"
  end

  def name_and_id
    "#{name} (#{id})"
  end

  def ethnicity
    other? ? self[:other_ethnicity] : self[:ethnicity]
  end

  def grouped_drafts
    applications.order('category asc').map do |application|
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
