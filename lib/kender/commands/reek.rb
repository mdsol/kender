module Kender
  class Reek < Command

    def available?
      #TODO: find a better to know if the executable is available.
      true # I'll try running it and not-fail if its not there
    end

    def command
      # doing simple echo to ignore error status.
      'reek app lib; echo ok'
    end

  end
end
