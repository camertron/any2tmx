module Any2Tmx
  class Traversable
    attr_reader :collection

    def initialize(collection)
      @collection = collection
    end

    def each_entry(&block)
      if block_given?
        each_entry_helper(collection, [], &block)
      else
        to_enum(__method__)
      end
    end

    def size
      each_entry.inject(0) { |ret, _| ret + 1 }
    end

    def dig(path)
      path.inject(:start) do |ret, seg|
        if ret == :start
          collection[seg]
        elsif ret
          if seg.is_a?(Numeric) && ret.is_a?(Array)
            ret[seg]  # array index case
          elsif seg.is_a?(String) && ret.is_a?(Hash)
            ret[seg]  # hash key case
          end
        end
      end
    end

    def zip(other_traversable)
      each_entry.each_with_object({}) do |(entry, path), ret|
        other_entry = other_traversable.dig(path)
        ret[entry] = other_entry if other_entry
        yield if block_given? && other_entry
      end
    end

    private

    def each_entry_helper(coll, path, &block)
      case coll
        when Hash
          coll.each_pair do |key, value|
            each_entry_helper(value, path + [key], &block)
          end

        when Array
          coll.each_with_index do |element, idx|
            each_entry_helper(element, path + [idx], &block)
          end

        when String
          yield coll, path
      end
    end
  end
end
