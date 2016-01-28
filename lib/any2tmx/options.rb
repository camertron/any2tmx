require 'optparse'

module Any2Tmx
  class Options
    attr_reader :errors

    def initialize(executable_name)
      @options = {}
      @errors = []

      OptionParser.new do |opts|
        opts.banner = "Usage: #{executable_name} [options]"

        opts.on('-s', '--source [file]:[locale]', 'File containing phrases in the source locale (locale appended with colon).') do |source|
          file, locale = source.split(':')
          @options[:source] = file
          @options[:source_locale] = locale
        end

        opts.on('-t', '--target [file]:[locale]', 'File containing translations in the target locale (locale appended with colon).') do |target|
          file, locale = target.split(':')
          @options[:target] = file
          @options[:target_locale] = locale
        end

        opts.on('-o', '--output [file]', 'The TMX output file to write. If not specified, output is printed to stdout.') do |output|
          @options[:output] = output
        end

        opts.on('-h', '--help', 'Prints this help message.') do
          @options[:help] = true
        end

        @opts = opts

        # give derived classes the opportunity to add additional options
        yield opts if block_given?
      end.parse!
    end

    def valid?
      errors.clear
      validate
      errors.empty?
    end

    def source
      @options[:source]
    end

    def target
      @options[:target]
    end

    def source_locale
      @options[:source_locale]
    end

    def target_locale
      @options[:target_locale]
    end

    def output
      @options[:output]
    end

    def help?
      @options[:help]
    end

    def print_help
      puts @opts
    end

    # allow derived classes to add additional validation routines
    def before_validate
    end

    def after_validate
    end

    private

    def validate
      unless help?
        before_validate
        validate_source
        validate_target
        validate_output
        after_validate
      end
    end

    def validate_source
      unless File.exist?(source)
        errors << 'Source file does not exist.'
      end

      unless source_locale
        errors << 'Source locale not provided. Try running with the -h option for usage details.'
      end
    end

    def validate_target
      unless File.exist?(target)
        errors << 'Target file does not exist.'
      end

      unless target_locale
        errors << 'Target locale not provided. Try running with the -h option for usage details.'
      end
    end

    def validate_output
      unless File.exist?(File.dirname(target))
        errors << 'Output path does not exist.'
      end
    end
  end
end
