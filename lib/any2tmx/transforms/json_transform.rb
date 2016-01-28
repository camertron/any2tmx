require 'json'

module Any2Tmx
  module Transforms
    class JsonTransform < Transform
      private

      def load(file, locale)
        phrases = JSON.parse(File.read(file))
        traversable = Any2Tmx::Traversable.new(phrases)
        Any2Tmx::PhraseSet.new(traversable, locale)
      end
    end
  end
end
