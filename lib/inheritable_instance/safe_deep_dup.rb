require "bigdecimal"

module InheritableInstance
  module SafeDeepDup
    extend self

    SKIP = [ NilClass, FalseClass, TrueClass,
             Symbol, Module, Method, UnboundMethod ].freeze

    def duplicate(obj)
      return duplicate_hash(obj)  if obj.is_a?(Hash)
      return duplicate_array(obj) if obj.is_a?(Array)
      return obj.dup if should_duplicate?(obj)
      obj
    end

    private

    def should_duplicate?(obj)
      return false if SKIP.any?{ |klass| obj.is_a?(klass) }
      return false if obj.is_a?(Numeric) && !obj.is_a?(BigDecimal)
      return false unless obj.respond_to?(:dup)
      !obj.respond_to?(:duplicable?) || obj.duplicable?
    end

    def duplicate_array(array)
      array.map{ |element| duplicate(element) }
    end

    def duplicate_hash(hash)
      hash.each_with_object(blank_hash(hash)) do |(k, v), copy|
        copy[duplicate(k)] = duplicate(v)
      end
    end

    def blank_hash(hash)
      return hash.dup.clear unless hash.class.equal?(Hash)
      hash.default_proc ? Hash.new(&hash.default_proc) :
                          Hash.new(hash.default)
    end

  end
end
