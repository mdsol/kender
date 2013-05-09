module Kender
  class TestUnit < Command

    def available?
      defined?(Test::Unit) and not(ENV['VALIDATE_PROJECT']
    end

    def command
      if defined?(ParallelTests)
        'rake parallel:test'
      else
        'rake test'
      end
    end

  end
end
