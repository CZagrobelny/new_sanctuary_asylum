class User < ActiveRecord::Base
  devise :invitable, :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  enum role: [:volunteer, :admin]

  validates :first_name, :last_name, :email, :phone, :presence => true
  validates :email, :uniqueness => true

  def volunteer?
  	self.role == 'volunteer'
  end

  def admin?
  	self.role == 'admin'
  end
end
