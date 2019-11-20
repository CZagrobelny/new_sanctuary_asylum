class Admin::StatsController < AdminController

  def index
    activities_with_count = []
    activities_count_by_week = confirmed_activities_by_week.map{ |week, activities| [Date.commercial(2019,week.to_i), activities.count] }
    activities_count_by_week.each do |activity|
      activities_with_count.push([activity[0],activity[1]])
    end

    accompaniments_with_count = []
    confirmed_activities_by_week.each do |activity|
      accompaniments = []
      activity[1].each do |a|
        a.accompaniments.each do |acc|
          accompaniments.push(acc)
        end
      end
      accompaniments_with_count.push([Date.commercial(2019,activity[0].to_i),accompaniments.count])
    end

    @data = [
      { name: 'Friends Accompanied', data: activities_with_count},
      { name: 'Volunteer Accompaniments', data: accompaniments_with_count}
    ]
  end

  private
    def confirmed_activities_by_week
      activities = Activity.confirmed.where(friend_id: current_community.friends).order('occur_at asc').group_by do |a|
        a.occur_at.strftime('%V')
      end
      activities
    end
end
