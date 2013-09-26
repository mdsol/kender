module Kender
  class Reek < Command

    def available?
      in_gemfile?('reek')
    end

    def command
      'bundle exec reek .'
    end

  end
end
