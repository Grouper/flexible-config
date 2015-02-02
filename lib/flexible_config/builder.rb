module FlexibleConfig
  class Builder
    def initialize(base_key = '')
      @base_key = base_key
    end

    def fetch(additional_key, default = nil, &block)
      key = "#{base_key}.#{additional_key}"

      WrappedEnv[key] || WrappedYaml[key] || default || (
        yield if block_given?
      ) || raise(NotFound.new key)
    end
    alias_method :[], :fetch

    private
    attr_reader :base_key
  end
end
