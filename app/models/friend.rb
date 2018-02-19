class Friend < ActiveRecord::Base
  enum ethnicity: [:white, :black, :hispanic, :asian, :south_asian, :caribbean, :indigenous, :other]
  enum gender: [:male, :female, :awesome]

  STATUSES = ['in_deportation_proceedings', 'not_in_deportation_proceedings', 'asylum_reciepient', 'asylum_application_denied', 'legal_permanent_resident', 'in_detention', 'green_card_holder'].map{|status| [status.titlecase, status]}
  ASYLUM_STATUSES = ['not_eligible', 'eligible', 'application_started', 'application_completed', 'application_submitted', 'granted', 'denied'].map{|status| [status.titlecase, status]}
  WORK_AUTHORIZATION_STATUSES = ['not_eligible', 'eligible', 'application_started', 'application_completed', 'application_submitted', 'granted', 'denied'].map{|status| [status.titlecase, status]}
  SIJS_STATUSES = ['qualifies', 'in_progress', 'submitted', 'approved', 'denied'].map{|status| [status.titlecase, status]}

  has_many :friend_languages, dependent: :destroy
  has_many :languages, through: :friend_languages
  has_many :parent_relationships, class_name: 'ParentChildRelationship', foreign_key: 'child_id', dependent: :destroy
  has_many :child_relationships, class_name: 'ParentChildRelationship', foreign_key: 'parent_id', dependent: :destroy
  has_many :parents, through: :parent_relationships
  has_many :children, through: :child_relationships
  has_many :sibling_relationships, dependent: :destroy
  has_many :siblings, through: :sibling_relationships
  has_many :inverse_sibling_relationships, class_name: 'SiblingRelationship', foreign_key: 'sibling_id', dependent: :destroy
  has_many :inverse_siblings, through: :inverse_sibling_relationships, source: :friend
  has_many :spousal_relationships, dependent: :destroy
  has_many :spouses, through: :spousal_relationships
  has_many :inverse_spousal_relationships, class_name: 'SpousalRelationship', foreign_key: 'spouse_id', dependent: :destroy
  has_many :inverse_spouses, through: :inverse_spousal_relationships, source: :friend
  has_many :partner_relationships, dependent: :destroy
  has_many :partners, through: :partner_relationships
  has_many :inverse_partner_relationships, class_name: 'PartnerRelationship', foreign_key: 'partner_id', dependent: :destroy
  has_many :inverse_partners, through: :inverse_partner_relationships, source: :friend
  has_many :activities, dependent: :restrict_with_error
  has_many :detentions, dependent: :destroy
  has_many :user_friend_associations, dependent: :destroy
  has_many :users, through: :user_friend_associations
  has_many :asylum_application_drafts, dependent: :restrict_with_error
  has_many :friend_event_attendances, dependent: :destroy
  has_many :events, through: :friend_event_attendances
  has_many :sijs_application_drafts, dependent: :restrict_with_error

  validates :first_name, :last_name, presence: true
  validates :zip_code, length: { is: 5 }, allow_blank: true, numericality: true
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
