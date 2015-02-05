CarrierWave.configure do |config|
    config.remove_previously_stored_files_after_update = false
end

if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
end
