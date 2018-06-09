desc 'Delete friend-volunteer associations that are more than 3 months old'
task remove_stale_friend_volunteer_associations: :environment do
  old_relations = UserFriendAssociation.where('created_at < ?', 3.months.ago)
  old_relations.destroy_all
end
