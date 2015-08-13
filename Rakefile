require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

import './lib/tasks/flexible_config.rake'

task :default => [:spec]

desc 'run Rspec specs'
task :spec do
  sh 'bundle exec rspec spec'
end
