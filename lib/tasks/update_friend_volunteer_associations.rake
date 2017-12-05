desc 'Delete friend-volunteer associations that are >= 3 months old'
task :update_friend_volunteer_associations => :environment do
  old_relations = UserFriendAssociation.where('created_at > ?', 3.months.ago)
  old_relations.destroy
end
