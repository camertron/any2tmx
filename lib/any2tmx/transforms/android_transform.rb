module Any2Tmx
  module Transforms
    class AndroidTransform < Transform
      private

      def load_file(file, locale)
        phrases = File.read(file)
        load(phrases, locale)
      end

      def load(contents, locale)
        contents = Any2Tmx::AndroidXmlParser.parse(contents)
        traversable = Any2Tmx::Traversable.new(contents)
        Any2Tmx::PhraseSet.new(traversable, locale)
      end
    end
  end
end
