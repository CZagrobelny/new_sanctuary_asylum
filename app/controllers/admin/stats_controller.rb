class Admin::StatsController < AdminController

  def index
    @activities_with_count = []
    activities_by_week = Activity.confirmed.where(friend_id: current_community.friends).order('occur_at asc').group_by do |a|
      a.occur_at.strftime('%V')
    end
    activities_count_by_week = activities_by_week.map{ |week, activities| [Date.commercial(2019,week.to_i), activities.count] }
    activities_count_by_week.each do |activity|
      @activities_with_count.push([activity[0],activity[1]])
    end
  end
end
