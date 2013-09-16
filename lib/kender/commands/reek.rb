module Kender
  class Reek < Command

    def available?
      in_gemfile?('reek')
    end

    def command
      # doing simple echo to ignore error status.
      'reek app lib; echo ok'
    end

  end
end
