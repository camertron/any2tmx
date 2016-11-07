require 'abroad'

module Any2Tmx
  class Transformer
    EXTRACTOR_EXTENSIONS = {
      '.yml'  => 'yaml/rails',
      '.json' => 'json/key-value',
      '.xml'  => 'android/xml'
    }

    attr_reader :options

    def initialize(options)
      @options = options
    end

    def transform
      source_phrases = extract_from(options.source[:file])
      result = source_phrases.each_with_object({}) do |(k, v), result|
        result[k] = { options.source[:locale] => v.to_s }
      end

      options.targets.each do |target|
        target_phrases = extract_from(target[:file])

        source_phrases.each_pair do |source_key, _|
          translation = target_phrases[source_key]

          if !translation.nil?
            result[source_key][target[:locale]] = translation.to_s
          end
        end
      end

      result
    end

    private

    def extract_from(file)
      {}.tap do |phrases|
        extractor.open(file) do |extractor|
          extractor.extract_each { |k, v| phrases[k] = v }
        end
      end
    end

    def extractor
      @extractor ||= Abroad.extractor(extractor_id)
    end

    def extractor_id
      EXTRACTOR_EXTENSIONS[source_extension]
    end

    def source_extension
      File.extname(options.source[:file])
    end
  end
end
