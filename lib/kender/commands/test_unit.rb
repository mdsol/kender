module Kender
  class TestUnit < Command

    def available?
      defined?(Test::Unit) and not(ENV['VALIDATE_PROJECT']
    end

    def command
      if defined?(ParallelTests)
        'bundle exec rake parallel:test'
      else
        'bundle exec rake test'
      end
    end

  end
end
