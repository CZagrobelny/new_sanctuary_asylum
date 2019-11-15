class Admin::StatsController < AdminController

  def index
    @activities_with_count = []
    confirmed_activities_by_week = Activity.confirmed.where(friend_id: current_community.friends).order('occur_at asc').group_by do |a|
      a.occur_at.strftime('%V')
    end
    activities_count_by_week = confirmed_activities_by_week.map{ |week, activities| [Date.commercial(2019,week.to_i), activities.count] }
    activities_count_by_week.each do |activity|
      @activities_with_count.push([activity[0],activity[1]])
    end

    @accompaniments_with_count = []

    accompaniments = []
    activities = Activity.where(friend_id: current_community.friends).order('occur_at asc')
    activities.each do |a|
      accompaniments.push(a.accompaniments)
    end

    parsed_accompaniments = []
    accompaniments.each do |a|
      a.each do |b|
        parsed_accompaniments.push(b)
      end
    end

    grouped_parsed_accompaniments = parsed_accompaniments.group_by do |a|
      a.created_at.strftime('%V')
    end

    accompaniments_count_by_week = grouped_parsed_accompaniments.map{ |week, accompaniments| [Date.commercial(2019,week.to_i), accompaniments.count] }
    accompaniments_count_by_week.each do |accompaniment|
      @accompaniments_with_count.push([accompaniment[0],accompaniment[1]])
    end
  end
end
