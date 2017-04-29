require "optparse"
require "digicert/cli/order_finder"

module Digicert
  module CLI
    module Command
      def self.load
        register_available_commands
      end

      def self.run(command, args = {})
        command_klass, method = extract_command(command)
        attributes = parse_option_arguments(args)

        command_klass.new(attributes).send(method || :list)
      end

      def self.parse(command)
        commands[command.to_s] || raise(ArgumentError)
      end

      def self.commands
        @@commands ||= {}
      end

      def self.register_available_commands
        commands["find-orders"] = { klass: "OrderFinder", method: :list }
      end

      def self.extract_command(command)
        parsed_command = parse(command)
        command_klass = Object.const_get(
          ["Digicert::CLI", parsed_command[:klass]].join("::"),
        )

        [command_klass, parsed_command[:method]]
      end

      def self.parse_option_arguments(args)
        attributes = {}

        option_parser = OptionParser.new do |parser|
          parser.banner = "Usage: digicert resource:action [options]"

          global_options.each do |option|
            attribute_name = option[1].split.first.gsub("--", "").to_sym
            parser.on(*option) { |value| attributes[attribute_name] = value}
          end
        end

        if args.first
          option_parser.parse!(args)
        end

        attributes
      end

      def self.global_options
        [
          ["-o", "--order_id ORDER_ID",  "The Digicert Order Id"],
          ["-c", "--common_name COMMON_NAME", "The common name for the order"],
          ["-p", "--product_type NAME_ID", "The Digicert product name Id"],
        ]
      end
    end
  end
end
