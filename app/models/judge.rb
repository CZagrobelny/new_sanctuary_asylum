class Judge < ApplicationRecord
  validates :first_name, :last_name, :region_id, presence: true
  belongs_to :region
  has_many :activities

  def name
  	"#{first_name} #{last_name}"
  end

end
