class ExampleClass
  FlexibleConfig.use 'category.subcategory' do |config|
    NO_CONFIG_BUT_DEFAULT = config.fetch('no_config') { 1 }
    ENV_OVERRIDE          = config.fetch('env_override') { nil }
    ENVIRONMENT_SPECIFIC  = config.fetch('environment_specific') { nil }
    DEFAULT_YAML          = config.fetch('default_yaml_config')
    TRUE_STRING           = config.fetch('true_string') { nil }
    FALSE_STRING          = config.fetch('false_string') { nil }
    SAFE_NUMBER           = config.to_i('safe_int') { nil }
  end

  FlexibleConfig.use 'category.another_sub' do |config|
    ONE = config['short_syntax']
    TWO = config['short_not_present', 0.5]
  end
end
