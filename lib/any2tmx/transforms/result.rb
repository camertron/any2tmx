module Any2Tmx
  module Transforms
    class Result
      attr_reader :source, :target, :collection, :processed_count

      def initialize(source, target, collection, processed_count)
        @source = source
        @target = target
        @collection = collection
        @processed_count = processed_count
      end

      def source_phrase_count
        source.traversable.size
      end

      def write(io)
        Any2Tmx::TmxWriter.write(
          collection, source.locale, target.locale, io
        )
      end
    end
  end
end
