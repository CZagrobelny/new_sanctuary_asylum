class Country < ActiveRecord::Base
	has_many :friends
end