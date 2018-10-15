class User < ApplicationRecord
  PRIMARY_ROLES = %w[volunteer accompaniment_leader admin].map { |k, _v| [k.humanize.titleize, k] }
  NON_PRIMARY_ROLES = %w[volunteer admin].map { |k, _v| [k.humanize.titleize, k] }

  devise :invitable, :database_authenticatable, :lockable,
         :recoverable, :rememberable, :trackable, :secure_validatable,
         :password_expirable, :password_archivable, :timeoutable,
         invite_for: 1.week
  attr_reader :raw_invitation_token

  enum role: %i[volunteer accompaniment_leader admin]
  enum volunteer_type: %i[english_speaking spanish_interpreter lawyer]

  validates :first_name, :last_name, :email, :phone, :volunteer_type, :community_id, presence: true
  validates :email, uniqueness: true
  validates_inclusion_of :pledge_signed, in: [true]

  belongs_to :community
  has_many :user_regions
  has_many :regions, through: :user_regions
  has_many :user_friend_associations, dependent: :destroy
  has_many :friends, through: :user_friend_associations
  has_many :user_draft_associations, dependent: :destroy
  has_many :drafts, through: :user_draft_associations
  has_many :accompaniments, dependent: :destroy
  has_many :user_event_attendances, dependent: :destroy
  has_many :accompaniment_reports, dependent: :destroy
  has_many :reviews

  scope :remote_lawyers, -> { where(remote_clinic_lawyer: true) }

  filterrific(
    default_filter_params: { sorted_by: 'created_at_desc' },
    available_filters: %i[
      search_query
      with_volunteer_type
      sorted_by
    ]
  )

  def self.options_for_sorted_by
    [
      ['Created at (newest first)', 'created_at_desc'],
      ['Created at (oldest first)', 'created_at_asc']
    ]
  end

  def remote_clinic_friends
    friends.where(user_friend_associations: { remote: true })
  end

  scope :sorted_by, ->(sort_option) {
    direction = sort_option =~ /desc$/ ? 'desc' : 'asc'
    case sort_option.to_s
    when /^created_at_/
      order("users.created_at #{direction}")
    when /^first_name_/
      order("LOWER(users.first_name) #{ direction }")
    when /^last_name_/
      order("LOWER(users.last_name) #{ direction }")
    when /^email_/
      order("users.email #{direction}")
    when /^admin?_/
      order("users.admin? #{direction}")
    else
      raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
    end
  }

  scope :search_query, lambda { |query|
  return nil  if query.blank?
  terms = query.downcase.split(/\s+/)
  terms = terms.map { |e|
    (e.gsub('*', '%') + '%').gsub(/%+/, '%')
  }
  # configure number of OR conditions for provision
  # of interpolation arguments. Adjust this if you
  # change the number of OR conditions.
  num_or_conds = 3
  where(
    terms.map { |term|
      "(LOWER(users.first_name) LIKE ? OR LOWER(users.last_name) LIKE ? OR LOWER(users.email) LIKE ?)"
    }.join(' AND '),
    *terms.map { |e| [e] * num_or_conds }.flatten
  )
}
  scope :with_volunteer_type, ->(volunteer_types) { where(volunteer_type: [*volunteer_types]) }

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
    else
      self.community == community
    end
  end

  def can_access_region?(region)
    regions.include?(region)
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
    admin? || existing_relationship?(friend_id)
  end
end
