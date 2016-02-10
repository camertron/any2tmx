require 'json'

module Any2Tmx
  module Transforms
    class JsonTransform < Transform
      private

      def load_file(file, locale)
        phrases = File.read(file)
        load(phrases)
      end

      def load(contents, locale)
        traversable = Any2Tmx::Traversable.new(JSON.parse(contents))
        Any2Tmx::PhraseSet.new(traversable, locale)
      end
    end
  end
end
