require 'yaml'

module Any2Tmx
  module Transforms
    class YamlTransform < Transform
      private

      def load_file(file, locale)
        phrases = File.read(file)
        load(phrases, locale)
      end

      def load(contents, locale)
        contents = YAML.load(contents)

        if contents.include?(locale)
          contents = contents[locale]
        end

        traversable = Any2Tmx::Traversable.new(contents)
        Any2Tmx::PhraseSet.new(traversable, locale)
      end
    end
  end
end
