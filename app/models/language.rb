class Language < ActiveRecord::Base
  has_many :friend_languages, dependent: :destroy
  has_many :friends, :through => :friend_languages
end