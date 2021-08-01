# To invoke -> rake "setup_region_for_community[4,CBST]"
# To invoke -> rake "setup_region_for_community[5,SOLIDARIDAD]"
desc 'Move a non-primary community into a new region and make it the primary community'
task :setup_region_for_community, [:community_id, :new_region_name] => :environment do |task, args|
  community = Community.find(args.community_id)

  ActiveRecord::Base.transaction do
    new_region = Region.create!(name: args.new_region_name)
    puts "Created region #{ new_region.inspect }"
    community.update_columns(region_id: new_region.id, primary: true)
    community.friends.update_all(region_id: new_region.id)
    Lawyer.all.each do |lawyer|
      referred_to = community.friends.where(lawyer_referred_to: lawyer.id)
      represented_by = community.friends.where(lawyer_represented_by: lawyer.id)
      sijs_lawyer = community.friends.where(sijs_lawyer: lawyer.id)
      next unless referred_to.present? || represented_by.present? || sijs_lawyer.present?

      puts "Friends referred_to #{ referred_to.map(&:id) }"
      puts "Friends represented_by #{ represented_by.map(&:id) }"
      puts "Friends sijs_lawyer #{ sijs_lawyer.map(&:id) }"
      new_lawyer = lawyer.clone
      new_lawyer.region_id = new_region.id
      new_lawyer.save!
      "Cloned new lawyer #{ new_lawyer.inspect }"
      referred_to&.update_all(lawyer_referred_to: new_lawyer.id)
      represented_by&.update_all(lawyer_represented_by: new_lawyer.id)
      sijs_lawyer&.update_all(sijs_lawyer: new_lawyer.id)
    end
    community.friends.each do |friend|
      friend.activities.update_all(region_id: new_region.id)
    end
    Judge.all.each do |judge|
      activities = new_region.activities.where(judge_id: judge.id)
      next unless activities.present?

      new_judge = judge.clone
      new_judge.region_id = new_region.id
      new_judge.save!
      "Cloned new judge #{ new_judge.inspect }"
      activities.update_all(judge_id: new_judge.id)
    end
    Location.all.each do |location|
      events = community.events.where(location_id: location.id)
      activities = new_region.activities.where(location_id: location.id)
      friend_ids = community.friends.pluck(:id)
      detentions = Detention.where(friend_id: friend_ids).where(location_id: location.id)
      next unless events.present? || activities.present? || detentions.present?

      puts "Location events #{ events.map(&:id) }"
      puts "Location activities #{ activities.map(&:id) }"
      puts "Location detentions #{ detentions.map(&:id) }"
      new_location = location.clone
      new_location.region_id = new_region.id
      new_location.save!
      "Cloned new location #{ new_location.inspect }"
      events&.update_all(location_id: new_location.id)
      activities&.update_all(location_id: new_location.id)
      detentions&.update_all(location_id: new_location.id)
    end
    community.remote_review_actions.update_all(region_id: new_region.id)
  end
end
