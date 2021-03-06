module FlexibleConfig
  class Overview
    def call
      available_files.reduce({}) do |memo, i|
        memo[i] = config_lines_for_file i
        memo
      end
    end

    def print
      call.each do |key, value|
        Kernel.puts "#===== #{key.upcase} (#{key}.yml) ====="
        value.each { |v| Kernel.puts v }
        Kernel.puts "\n"
      end
    end

    private

    def available_files
      WrappedYaml.config_data.keys
    end

    def config_lines_for_file(category)
      builder = FlexibleConfig::Builder.new category
      keys    = []

      WrappedYaml.config_data[category].values.each do |env|
        keys += flat_hash(env).keys
      end

      keys.uniq.sort.map do |keys|
        value = begin
          builder[keys.join '.']
        rescue FlexibleConfig::NotFound => e
          "### NO VALUE ###"
        end

        combined_keys = [category] + keys
        dotted_key    = keys.join '.'
        env_key       = combined_keys.map(&:upcase).join '_'
        from_env      = !WrappedEnv[env_key].nil? ? 'ENV OVERRIDE' : ''

        sprintf("%-40s|%-12s|  %-45s = %s",
          dotted_key, from_env, env_key, value
        )
      end
    end

    def flat_hash(h, f = [], g = {})
      return g.update(f => h) unless h.is_a? Hash
      h.each { |k, r| flat_hash r, f+[k], g }
      g
    end
  end
end
