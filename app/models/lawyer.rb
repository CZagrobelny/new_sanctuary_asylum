class Lawyer < ActiveRecord::Base
  validates :first_name, :last_name, presence: true
  def name
    "#{first_name} #{last_name}"
  end

  def name_and_organization
  	"#{first_name} #{last_name}, #{organization}"
  end
end