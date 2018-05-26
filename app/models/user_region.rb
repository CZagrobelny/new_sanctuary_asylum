class UserRegion < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :region
end
