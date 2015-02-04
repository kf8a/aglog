namespace :util do
  desc "move file attachments from note to notes"
  task :to_multi_file => :environment do
    Observation.where('notes is null').each do |observation|
      observation.notes << observation.note
      observation.save
    end
  end
end
