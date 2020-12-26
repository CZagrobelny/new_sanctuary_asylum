desc 'Archive Friend records due to inactivity'
task archive_friends: :environment do
  # identify friends from criteria
  # (lets make archive and unarchive model methods so they can be tested)
  # set archived to true and also delete any friend user associations (there shouldn't be any)
end