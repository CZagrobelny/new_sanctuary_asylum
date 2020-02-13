class Admin::StatsController < AdminController
  def index
    activities_with_count = confirmed_activities_by_week.map do |week, activities|
      [Date.commercial(*week), activities.count]
    end

    accompaniments_with_count = []
    confirmed_activities_by_week.each do |week, activities|
      accompaniment_count = 0
      activities.each do |a|
        accompaniment_count += a.accompaniments.size
      end
      accompaniments_with_count.push([Date.commercial(*week), accompaniment_count])
    end

    @data = [
      { name: 'Friends Accompanied', data: activities_with_count},
      { name: 'Volunteer Accompaniments', data: accompaniments_with_count}
    ]
    @xmin = 1.year.ago

  end

  private

  def confirmed_activities_by_week
    Activity.confirmed
      .includes(:accompaniments)
      .where(friend_id: current_community.friends)
      .where('occur_at > ?', 1.year.ago)
      .where('occur_at < ?', 1.week.from_now)
      .order('occur_at asc')
      .group_by do |a, b|
        a.occur_at.strftime('%Y %V').split.map(&:to_i)
      end
  end
end
