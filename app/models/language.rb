class Language < ActiveRecord::Base
  has_many :friends, :through => :friend_languages
end