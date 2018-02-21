class Sanctuary < ApplicationRecord
  validates :name, :leader_name, presence: true
end
