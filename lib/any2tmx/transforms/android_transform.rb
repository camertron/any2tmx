module Any2Tmx
  module Transforms
    class AndroidTransform < Transform
      private

      def load(file, locale)
        phrases = Any2Tmx::AndroidXmlParser.parse(File.read(file))
        traversable = Any2Tmx::Traversable.new(phrases)
        Any2Tmx::PhraseSet.new(traversable, locale)
      end
    end
  end
end
