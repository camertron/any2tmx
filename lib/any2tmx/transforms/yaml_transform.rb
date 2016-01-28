require 'yaml'

module Any2Tmx
  module Transforms
    class YamlTransform < Transform
      private

      def load(file, locale)
        phrases = YAML.load_file(file)

        if phrases.include?(locale)
          phrases = phrases[locale]
        end

        traversable = Any2Tmx::Traversable.new(phrases)
        Any2Tmx::PhraseSet.new(traversable, locale)
      end
    end
  end
end
