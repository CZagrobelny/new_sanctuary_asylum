class User < ApplicationRecord
  include PgSearch::Model

  PRIMARY_ROLES = %w[
    volunteer
    accompaniment_leader
    data_entry
    eoir_caller
    admin
    remote_clinic_lawyer
  ].map { |k, _v| [k.humanize.titleize, k] }.freeze
  NON_PRIMARY_ROLES = %w[
    volunteer
    data_entry
    eoir_caller
    admin
    remote_clinic_lawyer
  ].map { |k, _v| [k.humanize.titleize, k] }.freeze
  # The users who can attend accompaniments (NOT as accompaniment leaders)
  ACCOMPANIMENT_ELIGIBLE_ROLES = %w[volunteer data_entry eoir_caller].freeze

  devise :invitable, :database_authenticatable, :authy_authenticatable,
    :lockable, :authy_lockable, :recoverable, :rememberable, :trackable,
    :secure_validatable, :password_expirable, :password_archivable,
    :timeoutable, :session_limitable, invite_for: 1.week

  attr_reader :raw_invitation_token

  # Do not change the order of this Array!
  enum role: %i[
    volunteer
    accompaniment_leader
    admin
    data_entry
    eoir_caller
    remote_clinic_lawyer
  ]

  validates :first_name, :last_name, :email, :phone, :community_id, presence: true
  validates :email, uniqueness: true
  validates_inclusion_of :pledge_signed, in: [true]

  belongs_to :community
  has_many :access_time_slots, foreign_key: :grantee_id, class_name: 'AccessTimeSlot', dependent: :restrict_with_error
  has_many :access_time_slots_granted, foreign_key: :grantor_id, class_name: 'AccessTimeSlot', dependent: :restrict_with_error
  has_many :accompaniments, dependent: :destroy
  has_many :accompaniment_reports, dependent: :destroy
  has_many :user_draft_associations, dependent: :destroy
  has_many :drafts, through: :user_draft_associations
  has_many :user_friend_associations, dependent: :destroy
  has_many :friends, through: :user_friend_associations
  has_many :volunteer_languages, dependent: :destroy
  has_many :languages, through: :volunteer_languages
  has_many :user_regions
  has_many :regions, through: :user_regions
  has_many :reviews
  has_many :user_event_attendances, dependent: :destroy
  has_many :friend_notes, dependent: :restrict_with_error
  has_many :remote_review_actions, dependent: :restrict_with_error

  accepts_nested_attributes_for :user_friend_associations, allow_destroy: true

  scope :confirmed, -> { where('invitation_accepted_at IS NOT NULL') }

  filterrific(
    available_filters: %i[
      filter_first_name
      filter_last_name
      filter_email
      filter_phone_number
      filter_role
    ]
  )

  def remote_clinic_friends
    friends.where(user_friend_associations: { remote: true })
  end

  scope :filter_role, ->(role) {
    where(role: role)
  }

  pg_search_scope :filter_first_name, against: :first_name,
                                      using: { tsearch: { prefix: true } }

  pg_search_scope :filter_last_name, against: :last_name,
                                     using: { tsearch: { prefix: true } }

  pg_search_scope :filter_email, against: :email, using: { tsearch: { prefix: true } }

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
        "(LOWER(users.phone) LIKE ?)"
      }.join(" AND "),
      *number_chunks.flatten,
    )
  }

  pg_search_scope :autocomplete_name,
    against: [:first_name, :last_name],
    using: {
      tsearch: { prefix: true }
    }

  def has_active_data_entry_access_time_slot?
    data_entry? && access_time_slots.active.present?
  end

  def has_active_eoir_caller_access_time_slot?
    eoir_caller? && access_time_slots.active.present?
  end

  def confirmed?
    invitation_accepted_at.present?
  end

  def name
    "#{first_name} #{last_name}"
  end

  def attending?(activity)
    activity.users.include?(self)
  end

  def local_clinic_friends
    friends.where(user_friend_associations: { remote: false }).order('first_name ASC')
  end

  def accompaniment_report_for(activity)
    accompaniment_reports.where(activity_id: activity.id).first
  end

  def can_access_community?(community)
    if regional_admin?
      regions.include?(community.region)
    elsif remote_clinic_lawyer?
      user_friend_associations.remote.map { |association|
        association.friend.community
      }.include?(community)
    else
      self.community == community
    end
  end

  def can_access_region?(region)
    regional_admin? && regions.include?(region)
  end

  def regional_admin?
    admin? && user_regions.present?
  end

  ## This is used by devise timeoutable to dynamically set session time out when the user is inactive
  def timeout_in
    if admin?
      1.hour
    else
      3.days
    end
  end

  def existing_relationship?(friend_id)
    UserFriendAssociation.where(friend_id: friend_id, user_id: id).present?
  end

  def existing_remote_relationship?(friend_id)
    UserFriendAssociation.where(friend_id: friend_id, user_id: id, remote: true).present?
  end

  def relationship(friend)
    UserFriendAssociation.where(friend: friend, user: self).last
  end

  def admin_or_existing_relationship?(friend_id)
    admin? || has_active_data_entry_access_time_slot? || existing_relationship?(friend_id)
  end
end
