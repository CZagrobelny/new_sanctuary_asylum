class User < ActiveRecord::Base
  devise :invitable, :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, :invite_for => 2.days
  
  enum role: [:volunteer, :admin]
  enum volunteer_type: [:english_speaking, :spanish_interpreter, :lawyer]

  validates :first_name, :last_name, :email, :phone, :volunteer_type, :presence => true
  validates :email, uniqueness: true

  has_many :user_friend_associations, dependent: :destroy
  has_many :friends, through: :user_friend_associations
  has_many :user_asylum_application_draft_associations, dependent: :destroy
  has_many :asylum_application_drafts, through: :user_asylum_application_draft_associations
  has_many :accompaniements, dependent: :destroy

  def volunteer?
  	self.role == 'volunteer'
  end

  def self.search(query_string, page)
    query = '%' + query_string.downcase + '%'

    User.where('lower(first_name) LIKE ? 
               OR lower(last_name) LIKE ? 
               OR lower(email) LIKE ?', 
               query, query, query).order('created_at desc')
                                   .paginate(page: page)
  end

  def admin?
  	self.role == 'admin'
  end

  def confirmed?
    self.invitation_accepted_at.present?
  end

  def name
    "#{first_name} #{last_name}"
  end

  def attending?(activity)
    activity.volunteers.include?(self)
  end
end
