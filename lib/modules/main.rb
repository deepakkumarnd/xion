module Xion
  module Main
    class Show < Command
      def initialize(args)
        @subcommand = args[0]
      end

      def run
        case @subcommand
        when 'options' then Opts.show
        when 'help' then App.show_help
        end
      end
    end

    class Clear < Command
      def initialize(args)
        @subcommand = args[0]
      end

      def run
        case @subcommand
        when 'options' then Opts.clear
        when 'screen', nil then puts "\e[H\e[2J"
        end
      end
    end

    class Set < Command
      def initialize(args)
        @key   = args[0]
        @value = args[1]
      end

      def run
        Opts.add(@key, @value)
      end
    end

    class Run < Command
      def run
        super
      end
    end

    class Exit < Command
      def run
        exit(0)
      end
    end

    class Use < Command
      def initialize(args)
        @module_name = args[0]
      end

      def run
        App.change_module(@module_name)
      end
    end

    def self.help
      "No help topic is available, please update"
    end
  end
end