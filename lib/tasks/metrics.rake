unless Rails.env.production?
require 'metric_fu'

MetricFu::Configuration.run do |config|
  config.metrics -= [:rcov, :roodi]
  config.graphs -= [:rcov, :roodi]
  config.flay = {   :dirs_to_flay => ['app', 'lib'],
                    :minimum_score => 0,
                    :filetypes => ['rb'] }
end
end
