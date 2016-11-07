require 'xml-write-stream'

module Any2Tmx
  class TmxWriter
    class << self
      def write(trans_map, options, io)
        writer = XmlWriteStream.from_stream(io)
        writer.open_tag('tmx', version: '1.4')
        writer.open_single_line_tag('header', srclang: options.source[:locale], datatype: 'plaintext', segtype: 'paragraph')
        writer.close_tag

        writer.open_tag('body')

        trans_map.each_pair do |_, target_translations|
          writer.open_tag('tu')

          target_translations.each do |locale, translation|
            writer.open_tag('tuv', 'xml:lang' => locale)
            writer.open_single_line_tag('seg')
            writer.write_text(translation)
            writer.close_tag  # seg
            writer.close_tag  # tuv
          end

          writer.close_tag  # tu
        end

        writer.close
      end
    end
  end
end
