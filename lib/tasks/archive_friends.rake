desc 'Archive Friend records due to inactivity'
task archive_friends: :environment do
  friends = Friend
    .where(archived: false)
    .where('updated_at < ?', 1.year.ago)
    .where.not(status: 'in_detention')
    .includes(:activities, :drafts, :friend_notes)

  friends.each do |friend|
    next if friend.activities.where('occur_at > ?', Time.now).size > 0
    next if friend.drafts.where('updated_at > ?', 1.year.ago).size > 0
    next if friend.friend_notes.where('updated_at > ?', 1.year.ago).size > 0

    friend.archive
  end
end
