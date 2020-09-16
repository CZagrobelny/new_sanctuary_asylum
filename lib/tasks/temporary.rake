namespace :temporary do
  desc 'Migrate remote clinic lawyers'
  task migrate_remote_clinic_lawyers: :environment do
    User.where(remote_clinic_lawyer: true).update_all(role: 'remote_clinic_lawyer')
  end
end
