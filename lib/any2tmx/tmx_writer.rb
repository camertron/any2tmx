require 'xml-write-stream'

module Any2Tmx
  class TmxWriter
    class << self
      def write(trans_map, source_locale, target_locale, io)
        writer = XmlWriteStream.from_stream(io)
        writer.open_tag('tmx', version: '1.4')
        writer.open_single_line_tag('header', srclang: source_locale, datatype: 'plaintext', segtype: 'paragraph')
        writer.close_tag

        writer.open_tag('body')

        trans_map.each_pair do |source_phrase, target_phrase|
          writer.open_tag('tu')
          writer.open_tag('tuv', 'xml:lang' => source_locale)
          writer.open_single_line_tag('seg')
          writer.write_text(source_phrase)
          writer.close_tag  # seg
          writer.close_tag  # tuv

          writer.open_tag('tuv', 'xml:lang' => target_locale)
          writer.open_single_line_tag('seg')
          writer.write_text(target_phrase)
          writer.close_tag  # seg
          writer.close_tag  # tuv
          writer.close_tag  # tu
        end

        writer.close
      end
    end
  end
end
