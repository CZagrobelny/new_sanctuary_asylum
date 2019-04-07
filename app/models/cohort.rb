class Cohort < ApplicationRecord
  belongs_to :community
  has_many :friend_cohort_assignments, dependent: :destroy
  has_many :friends, through: :friend_cohort_assignments
  validates :start_date, :color, :community_id, presence: true

  COLORS = [
    ['Navy', '#001f3f'],
    ['Blue', '#0074D9'],
    ['Aqua', '#7FDBFF'],
    ['Teal', '#39CCCC'],
    ['Olive', '#3D9970'],
    ['Green', '#2ECC40'],
    ['Lime', '#01FF70'],
    ['Yellow', '#FFDC00'],
    ['Orange', '#FF851B'],
    ['Red', '#FF4136'],
    ['Maroon', '#85144b'],
    ['Fuchsia', '#F012BE'],
    ['Purple', '#B10DC9']
  ]

  def friend_assignments
    friend_cohort_assignments.includes(:friend).order('created_at desc')
  end
end
