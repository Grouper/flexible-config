module FlexibleConfig
  class NotFound < RuntimeError
    def initialize(key = 'unknown.key')
      super error_message_from key
    end

    private

    def error_message_from(key)
      file_base_name, *yml_keys = key.split '.'

      env_var     = key.upcase.gsub '.', '_'
      environment = WrappedEnv.fetch('RAILS_ENV') { 'default' }
      yml_key     = "#{environment}.#{yml_keys.join '.'}"
      file_name   = "./config/settings/#{file_base_name}.yml"

      "#{self.class} Exception. Configuration value not found. Consider " \
        "setting the #{env_var} environment variable, or setting the " \
        "#{yml_key} property in the following file: #{file_name}"
    end
  end
end
