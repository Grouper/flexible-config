class ExampleClass
  FlexibleConfig.use 'category.subcategory' do |config|
    NO_CONFIG_BUT_DEFAULT = config.fetch('no_config')            { 1 }
    ENV_OVERRIDE          = config.fetch('env_override')         { 2 }
    ENVIRONMENT_SPECIFIC  = config.fetch('environment_specific') { 3 }
    DEFAULT_YAML          = config.fetch('default_yaml_config')  { 4 }
  end

  FlexibleConfig.use 'category.another_sub' do |config|
    ONE = config['short_syntax']
    TWO = config['short_not_present', 0.5]
  end
end
