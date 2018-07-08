class Lawyer < ApplicationRecord
  belongs_to :region
  validates :first_name, :last_name, :region_id, presence: true

  def name
    "#{first_name} #{last_name}"
  end

  def name_and_organization
    "#{first_name} #{last_name}, #{organization}"
  end
end
