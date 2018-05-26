class User < ApplicationRecord
  devise :invitable, :database_authenticatable, :lockable, :recoverable, :rememberable, :trackable, :secure_validatable, :password_expirable, :password_archivable, :timeoutable, :invite_for => 1.week
  attr_reader :raw_invitation_token

  enum role: [:volunteer, :accompaniment_leader, :admin]
  enum volunteer_type: [:english_speaking, :spanish_interpreter, :lawyer]

  validates :first_name, :last_name, :email, :phone, :volunteer_type, :presence => true
  validates :email, uniqueness: true
  validates_inclusion_of :pledge_signed, :in => [true]

  belongs_to :community
  has_many :user_regions
  has_many :regions, through: :user_regions
  has_many :user_friend_associations, dependent: :destroy
  has_many :friends, through: :user_friend_associations
  has_many :user_application_draft_associations, dependent: :destroy
  has_many :application_drafts, through: :user_application_draft_associations
  has_many :accompaniments, dependent: :destroy
  has_many :user_event_attendances, dependent: :destroy
  has_many :accompaniment_reports, dependent: :destroy

  def confirmed?
    self.invitation_accepted_at.present?
  end

  def name
    "#{first_name} #{last_name}"
  end

  def attending?(activity)
    activity.users.include?(self)
  end

  def accompaniment_report_for(activity)
    self.accompaniment_reports.where(activity_id: activity.id).first
  end

  ## This is used by devise timeoutable to dynamically set session time out when the user is inactive
  def timeout_in
    if admin?
      1.hour
    else
      3.days
    end
  end
end
