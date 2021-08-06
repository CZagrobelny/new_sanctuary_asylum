namespace :temporary do
  desc 'move remote clinic lawyers from nyc to cbst'
  task move_remote_clinic_lawyers_to_cbst: :environment do
    User.where(role: 'remote_clinic_lawyer').each do |user|
      cbst_and_solidaridad_ids = [4, 5]
      move_to_cbst = false

      if RemoteReviewAction.where(user_id: user.id, community_id: cbst_and_solidaridad_ids).present?
        move_to_cbst = true
      end

      Friend.where(community_id: cbst_and_solidaridad_ids).each do |friend|
        break if move_to_cbst
        friend.drafts.each do |draft|
          break if move_to_cbst
          if draft.reviews.where(user_id: user.id).present?
            move_to_cbst = true
          end
        end
      end

      if move_to_cbst
        user.update_columns(community_id: 4)
        puts "Moved #{ user.id } #{ user.name } to CBST"
      end
    end
  end

  desc 'import files'
  task import_files: :environment do
    Draft.all.each do |draft|
      next if draft.document.present?
      file = import_file(draft)
      next unless file

      draft.document.attach(
        io:  file,
        filename: draft.pdf_draft.file.filename,
      )
      puts "Attached #{ draft.pdf_draft.file.filename } to #{ draft.id } for Friend #{ draft.friend.id }"
    end
  end

  def import_file(draft)
    URI.open(draft.pdf_draft_url)
  rescue => error
    puts "Import failed for draft #{ draft.id }"
    puts error
    nil
  end
end
