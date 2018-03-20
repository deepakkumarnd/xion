module Xion
  module Net
    def self.help
      "No help topic is available, please update"
    end

    class Scan < Command
      def run
        puts "Scanning with " + Opts.options.inspect
      end
    end
  end
end