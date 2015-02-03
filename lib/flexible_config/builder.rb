module FlexibleConfig
  UnsafeConversion = Class.new(RuntimeError)

  class Builder
    def initialize(base_key = '')
      @base_key = base_key
    end

    def fetch(additional_key, default = nil)
      key  = "#{base_key}.#{additional_key}"
      item = [WrappedEnv[key], WrappedYaml[key], default].detect { |i| !i.nil? }

      return item unless item.nil?
      return yield if block_given?

      raise NotFound.new key
    end
    alias_method :[], :fetch

    def method_missing(method, *args, &block)
      value = fetch(*args, &block)
      return super unless value.respond_to? method

      result = value.send method

      raise UnsafeConversion.new(
        "Tried to convert #{value} to int #{result} but was deemed unsafe."
      ) unless result.to_s == value.to_s

      result
    end

    private
    attr_reader :base_key
  end
end
