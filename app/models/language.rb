class Language < ApplicationRecord
  has_many :friend_languages, dependent: :destroy
  has_many :friends, through: :friend_languages
  has_many :volunteer_languages, dependent: :destroy
  has_many :users, through: :volunteer_languages
  
end
