class Judge < ApplicationRecord
  validates :first_name, :last_name, :region_id, presence: true
  belongs_to :region
  has_many :activities, dependent: :restrict_with_error

  scope :active, -> { where(hidden: false) }
  scope :hidden, -> { where(hidden: true) }

  def active?
    hidden == false
  end

  def hidden?
    hidden == true
  end

  def name
    "#{first_name} #{last_name}"
  end
end
