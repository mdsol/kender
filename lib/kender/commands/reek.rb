module Kender
  class Reek < Command

    def available?
      false # true # I'll try running it and not-fail if its not there
    end

    def command
      'reek app lib; echo ok'
    end

  end
end
