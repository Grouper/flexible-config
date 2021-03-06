module FlexibleConfig
  class WrappedYaml
    CONFIG_PATH = "config/settings/**/*.yml"

    class << self
      def [](key)
        environment_specific = get_config(key, env: app_environment)
        environment_specific.nil? ? get_config(key) : environment_specific
      end

      def config_data
        @config_data ||= Dir[CONFIG_PATH].reduce({}) do |memo, file|
          category = File.basename(file, '.yml')
          memo[category] = YAML.load File.open file
          memo
        end
      end

      private

      def get_config(key, env: 'default')
        keys_with_injected_env = key.sub('.', ".#{env}.").split '.'

        keys_with_injected_env.reduce(config_data) do |memo, i|
          memo[i] unless memo.nil?
        end
      end

      def app_environment
        (
          ENV['CONFIG_ENV'] ||
          ENV['RAILS_ENV']  ||
          ENV['RACK_ENV']   ||
          'development'
        )
      end
    end
  end
end
