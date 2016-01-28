module Any2Tmx
  module Transforms
    class Transform
      attr_reader :options

      def initialize(options)
        @options = options
      end

      def result
        source = load(options.source, options.source_locale)
        target = load(options.target, options.target_locale)
        count = 0
        zipped = source.zip(target) { count += 1 }
        Result.new(source, target, zipped, count)
      end

      private

      def load(file, locale)
        raise NotImplementedError,
          "#{__method__} must be defined in derived classes"
      end
    end
  end
end
