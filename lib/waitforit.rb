require "waitforit/version"

module Waitforit
  class Parser
    def run args
      command, port = *args
      port = "3001" unless port
      case command
      when "start" then lag.start! port
      when "stop"  then lag.stop! port
      else print_usage
      end
    end

    def lag
      Lag.new
    end

    def print_usage
      puts
      puts "Usage: waitforit [start|stop] port"
      puts "Example: waitforit start 3000"
      puts
      puts "Experimental; use at your own risk."
    end
  end

  class CommandLine
    def run command
      puts command
      `#{command}`
    end
  end

  class Lag
    def start! port
      c = CommandLine.new
      c.run "sudo ipfw pipe 1 config bw 1024Kbit/s delay 10ms"
      c.run "sudo ipfw add 1 pipe 1 src-port #{port}"
      c.run "sudo ipfw add 2 pipe 1 dst-port #{port}"
    end
    def stop! port
      c = CommandLine.new
      c.run "sudo ipfw delete 1"
      c.run "sudo ipfw delete 2"
      c.run "sudo ipfw pipe 1 delete"
    end
  end
end
