$LOAD_PATH.unshift File.expand_path '../lib', __FILE__
require 'flexible_config/version'

Gem::Specification.new do |s|
	s.name         = 'flexible-config'
	s.summary      = 'Flexible Configuration for Ruby constants'
	s.description  = 'Use environment-specific YAML for configuration while allowing for ENV variables to override'
	s.version      =  FlexibleConfig::VERSION
	s.date         = '2015-02-01'
	s.homepage     = 'http://www.joingrouper.com'
	s.authors      = ['Brett Richardson']
	s.email        = ['brett@joingrouper.com']
	s.require_path = 'lib'
	s.files        = Dir.glob('lib/**/*') + %w{Gemfile Guardfile MIT-LICENSE README.md}

  s.add_dependency 'activesupport'

	s.add_development_dependency 'bundler'
	s.add_development_dependency 'rake'
	s.add_development_dependency 'guard'
	s.add_development_dependency 'guard-rspec'
	s.add_development_dependency 'guard-bundler'
	s.add_development_dependency 'growl'
	s.add_development_dependency 'pry'
end
