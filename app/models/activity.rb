class Activity < ActiveRecord::Base

  belongs_to :friend
  belongs_to :judge
  belongs_to :location

end
