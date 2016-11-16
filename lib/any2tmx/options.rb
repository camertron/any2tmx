require 'optparse'

module Any2Tmx
  class Options
    attr_reader :errors

    def initialize(executable_name)
      @options = { targets: [] }
      @errors = []

      OptionParser.new do |opts|
        opts.banner = "Usage: #{executable_name} [options]"

        opts.on('-s', '--source [file]:[locale]', 'File containing phrases in the source locale (locale appended with colon).') do |source|
          file, locale = source.split(':')
          @options[:source] = { file: file, locale: locale }
        end

        opts.on('-t', '--target [file]:[locale]', 'File containing translations in the target locale (locale appended with colon).') do |target|
          file, locale = target.split(':')
          @options[:targets] << { file: file, locale: locale }
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

    def targets
      @options[:targets]
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
        validate_targets
        validate_output
        after_validate
      end
    end

    def validate_source
      unless File.exist?(source[:file])
        errors << "Source file #{source[:file]} does not exist."
      end

      unless source[:locale]
        errors << 'Source locale not provided. Try running with the -h option for usage details.'
      end
    end

    def validate_targets
      targets.each do |target|
        unless File.exist?(target[:file])
          errors << "Target file #{target[:file]} does not exist."
        end

        unless target[:locale]
          errors << 'Target locale not provided. Try running with the -h option for usage details.'
        end
      end
    end

    def validate_output
      if output && !File.exist?(File.dirname(output))
        errors << 'Output path does not exist.'
      end
    end
  end
end
