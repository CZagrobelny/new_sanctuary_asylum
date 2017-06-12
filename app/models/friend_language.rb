class FriendLanguage < ActiveRecord::Base
  belongs_to :friend
  belongs_to :language
end