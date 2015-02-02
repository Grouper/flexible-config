module FlexibleConfig
  module WrappedEnv
    class << self
      def [](generic_key)
        key = normalize_key generic_key
        normalize(overrides.key?(key) ? overrides[key] : ENV[key])
      end

      def fetch(generic_key, &block)
        key = normalize_key generic_key
        return overrides[key] if overrides.key?(key)

        normalize ENV.fetch(key, &block)
      rescue KeyError => e
        raise NotFound.new key
      end

      def int(generic_key, &block)
        key = normalize_key generic_key
        val = fetch(key)
        return block.call if val.nil? && block_given?

        raise NotFound.new if val.nil?
        val.to_i
      end

      def normalize(val)
        case val.to_s.downcase
        when 'true'  then true
        when 'false' then false
        when ''      then nil
        else val
        end
      end

      def override(key, value)
        overrides[key] = value
      end

      def reset
        @overrides = {}
      end

      private

      def overrides
        @overrides ||= {}
      end

      def normalize_key(key)
        key.upcase.gsub('.', '_')
      end
    end
  end
end
