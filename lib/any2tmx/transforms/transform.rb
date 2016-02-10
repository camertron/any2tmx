module Any2Tmx
  module Transforms
    class Transform
      attr_reader :options

      def initialize(options)
        @options = options
      end

      def result
        source = read(options.source, options.source_locale)
        target = read(options.target, options.target_locale)
        count = 0
        zipped = source.zip(target) { count += 1 }
        Result.new(source, target, zipped, count)
      end

      private

      def read(location_or_contents, locale)
        if File.exist?(location_or_contents)
          load_file(location_or_contents, locale)
        else
          load(location_or_contents, locale)
        end
      end

      def load_file(file, locale)
        raise NotImplementedError,
          "#{__method__} must be defined in derived classes"
      end

      def load(file, locale)
        raise NotImplementedError,
          "#{__method__} must be defined in derived classes"
      end
    end
  end
end
