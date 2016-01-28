require 'nokogiri'
require 'htmlentities'

# These classes have been adapted from:
# https://github.com/rosette-proj/rosette-extractor-xml

class HTMLEntities
  MAPPINGS['android_xml'] = MAPPINGS['xhtml1'].dup.tap do |mappings|
    mappings.delete('apos')
  end

  FLAVORS << 'android_xml'

  class AndroidXmlDecoder < Decoder
    def initialize
      super('android_xml')
    end
  end
end

module Any2Tmx
  class AndroidXmlParser
    class << self
      def parse(xml_content)
        doc = parse_xml(xml_content)
        result = {}.tap do |result|
          collector = lambda { |text, key| result[key] = text }
          each_string_entry(doc, &collector)
          each_array_entry(doc, &collector)
          each_plural_entry(doc, &collector)
        end
      end

      protected

      def parse_xml(xml_content)
        Nokogiri::XML(xml_content) do |config|
          config.options = Nokogiri::XML::ParseOptions::NONET
        end
      end

      def each_string_entry(doc)
        doc.xpath('//string').each do |node|
          yield(
            text_from(node),
            name_from(node)
          )
        end
      end

      def each_array_entry(doc)
        doc.xpath('//string-array').each do |array|
          prefix = name_from(array)

          array.xpath('item').each_with_index do |item, idx|
            yield(
              text_from(item),
              "#{prefix}.#{idx}"
            )
          end
        end
      end

      def each_plural_entry(doc)
        doc.xpath('//plurals').each do |plurals|
          prefix = name_from(plurals)

          plurals.xpath('item').each do |item|
            quantity = item.attributes['quantity'].value

            yield(
              text_from(item),
              "#{prefix}.#{quantity}"
            )
          end
        end
      end

      def text_from(node)
        builder = Nokogiri::XML::Builder.new do |builder|
          builder.root do
            node.children.each do |child|
              serialize(child, builder)
            end
          end
        end

        # safe to call `strip` after `to_xml` because any string that
        # needs leading or trailing whitespace preserved should be wrapped
        # in double quotes
        unescape(
          strip_enclosing_quotes(
            builder.doc.xpath('/root/node()').to_xml.strip
          )
        )
      end

      def serialize(node, builder)
        if node.text?
          builder.text(unescape(node.text))
        else
          builder.send("#{node.name}_", node.attributes) do
            node.children.each do |child|
              serialize(child, builder)
            end
          end
        end
      end

      def name_from(node)
        if attribute = node.attributes['name']
          attribute.value
        end
      end

      def unescape(text)
        text = text
          .gsub("\\'", "'")
          .gsub('\\"', '"')
          .gsub("\\n", "\n")
          .gsub("\\r", "\r")
          .gsub("\\t", "\t")

        coder.decode(text)
      end

      def coder
        @coder ||= HTMLEntities::AndroidXmlDecoder.new
      end

      def strip_enclosing_quotes(text)
        quote = case text[0]
          when "'", '"'
            text[0]
        end

        if quote
          text.gsub(/\A#{quote}(.*)#{quote}\z/) { $1 }
        else
          text
        end
      end

    end
  end
end
