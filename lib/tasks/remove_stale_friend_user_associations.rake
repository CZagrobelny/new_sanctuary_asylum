desc 'Delete friend-user associations that are more than 8 weeks old'
task remove_stale_friend_user_associations: :environment do
  old_relations = UserFriendAssociation.where('created_at < ?', 8.weeks.ago)
  old_relations.destroy_all
end