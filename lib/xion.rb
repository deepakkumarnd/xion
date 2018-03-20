require_relative 'core'
require_relative 'error'
require_relative 'modules/main'
require_relative 'modules/net'

module Xion
  VERSION = 0.1

  Opts = Options.instance
  App = Application.instance

  App.register_module('main')
  App.register_module('net')

  puts "Xion: Version #{VERSION}"

  loop do
    App.show_prompt
    command, *args = App.input

    begin
      App.run_command(command, args)
    rescue CommandNotFoundError
      puts "Command `#{command}` not found"
    end
  end
end