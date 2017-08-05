class Friend < ActiveRecord::Base
  enum ethnicity: [:white, :black, :hispanic, :asian, :south_asian, :caribbean, :indigenous, :other]
  enum gender: [:male, :female, :awesome]
  enum status: [:in_deportation_proceedings, :not_in_deportation_proceedings, :asylum_reciepient, :asylum_application_denied, :legal_permanent_resident, :in_detention, :green_card_holder]
  enum asylum_status: [:asylum_not_eligible, :asylum_eligible, :asylum_application_started, :asylum_application_completed, :asylum_application_submitted, :asylum_granted, :asylum_denied]
  enum work_authorization_status: [:work_authorization_not_eligible, :work_authorization_eligible, :work_authorization_application_started, :work_authorization_application_completed, :work_authorization_application_submitted, :work_authorization_granted, :work_authorization_denied]
  enum sijs_status: [:sijs_not_eligible, :sijs_eligible, :sijs_application_started, :sijs_application_completed, :sijs_application_submitted, :sijs_granted, :sijs_denied]

  has_many :friend_languages, dependent: :destroy
  has_many :languages, through: :friend_languages
  has_many :parent_relationships, class_name: 'ParentChildRelationship', foreign_key: 'child_id', dependent: :destroy
  has_many :child_relationships, class_name: 'ParentChildRelationship', foreign_key: 'parent_id', dependent: :destroy
  has_many :parents, through: :parent_relationships
  has_many :children, through: :child_relationships
  has_many :spousal_relationships, dependent: :destroy
  has_many :spouses, through: :spousal_relationships
  has_many :inverse_spousal_relationships, class_name: 'SpousalRelationship', foreign_key: 'spouse_id', dependent: :destroy
  has_many :inverse_spouses, through: :inverse_spousal_relationships, source: :friend
  has_many :activities, dependent: :destroy
  has_many :user_friend_associations, dependent: :destroy
  has_many :users, through: :user_friend_associations
  has_many :asylum_application_drafts, dependent: :destroy
  has_many :friend_event_attendances, dependent: :destroy
  has_many :events, through: :friend_event_attendances

  validates :first_name, :last_name, presence: true
  validates :a_number, presence: { if: :a_number_available? }, numericality: { if: :a_number_available? }
  validates :a_number, length: { minimum: 8, maximum: 9 }, if: :a_number_available?
  validates_uniqueness_of :a_number, if: :a_number_available?

  def name
    "#{first_name} #{last_name}"
  end

  def ethnicity
    self.other? ? self[:other_ethnicity] : self[:ethnicity]
  end

  private

  def a_number_available?
    self.no_a_number == false
  end
end
