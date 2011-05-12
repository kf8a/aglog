require 'metric_fu'

MetricFu::Configuration.run do |config|
  config.metrics -= [:rcov, :flog, :roodi]
  config.graphs -= [:rcov, :flog, :roodi]
  config.flay = {   :dirs_to_flay => ['app', 'lib'],
                    :minimum_score => 0,
                    :filetypes => ['rb'] }
end
