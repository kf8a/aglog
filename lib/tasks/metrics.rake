require 'metric_fu'

MetricFu::Configuration.run do |config|
  config.rcov[:rcov_opts] << "-Itest"
  config.flay = {   :dirs_to_flay => ['app', 'lib'],
                    :minimum_score => 0,
                    :filetypes => ['rb'] }
end
