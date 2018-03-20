require 'singleton'

module Xion
  class Command
    def initialize(*args)
      @args = args
    end

    def run
      # implement command in the subclass
    end

    def self.help
      "No help topic is available, please update"
    end
  end

  class Application
    include Singleton

    attr_reader :current_module

    def initialize
      @command_registry = {}
      @module_registry  = {}
      @current_module   = nil
    end

    def prompt
      "#{@current_module_name} >> "
    end

    def show_prompt
      print prompt
    end

    def input
      line = gets.strip
      line.split.map(&:strip)
    end

    def show_help
      list_commands
    end

    def list_commands
      @command_registry.each do |command, klass|
        puts "#{command}\t #{klass.help}"
      end
    end

    def register_command(command, klass)
      @command_registry[command] = klass
    end

    def run_command(command, args)
      raise CommandNotFoundError unless @command_registry.has_key? command
      @command_registry[command].new(args).run
    end

    def list_modules
      @module_registry.each do |module_name, module_const|
        puts "#{module_name}\t #{module_const.help}"
      end
    end

    def register_module(module_name, module_const =  nil)
      mod = module_const || resolve_module_name(module_name)
      @module_registry[module_name] = mod
      mod.constants.each do |const|
        klass = mod.const_get(const)
        if klass.is_a?(Class) && (klass.superclass == Command)
          register_command(klass.to_s.split('::').last.to_s.downcase, klass)
        end
      end
    end

    def change_module(module_name)
      raise ModuleNotLoadedError unless @module_registry.has_key? module_name
      @current_module = @module_registry[module_name]
      @current_module_name = module_name
      Opts.clear
    end

    private

    # def resolve_command_class(command)
    #   klass = Kernel.const_get(command.capitalize)
    #   raise CommandNotFoundError unless klass.superclass == Command
    #   klass
    # end

    def resolve_module_name(module_name)
      module_const = Xion.const_get(module_name.capitalize)
      raise ModuleNotLoadedError unless module_const.class == Module
      module_const
    end
  end

  class Options
    include Singleton

    def initialize
      @options = {}
    end

    def options
      @options
    end

    def add(key, value)
      @options[key] = value
    end

    def clear
      @options = {}
    end

    def show
      @options.each do |key, value|
        puts "#{key} = #{value}"
      end
    end
  end
end