class AccompanimentReport < ActiveRecord::Base
  belongs_to :activity
  has_many :accompaniment_report_authorships, dependent: :destroy
  has_many :users, through: :accompaniment_report_authorships
end