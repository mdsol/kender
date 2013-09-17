module Kender
  class Reek < Command

    def available?
      in_gemfile?('reek')
    end

    def command
      'reek app lib'
    end

  end
end
