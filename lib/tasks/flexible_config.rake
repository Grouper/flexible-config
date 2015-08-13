namespace :flexible_config do
  task :print do
    require 'flexible-config'
    FlexibleConfig::Overview.new.print
  end
end
