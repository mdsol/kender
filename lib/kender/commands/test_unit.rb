module Kender
  class TestUnit < Command

    def available?
      in_gemfile?('test-unit') and not(ENV['VALIDATE_PROJECT'])
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
