class User < ActiveRecord::Base
  devise :invitable, :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  
  enum role: [:volunteer, :admin]
  enum volunteer_type: [:english_speaking, :spanish_interpreter, :lawyer]

  validates :first_name, :last_name, :email, :presence => true
  validates :email, :uniqueness => true

  def volunteer?
  	self.role == 'volunteer'
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
end
