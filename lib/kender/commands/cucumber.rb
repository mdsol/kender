module Kender
  class Cucumber < Command

    def available?
      defined?(Cucumber) and not(ENV['VALIDATE_PROJECT'])
    end

    def command
      if defined?(ParallelTests)
        'bundle exec rake parallel:features'
      else
        'bundle exec cucumber'
      end
    end

  end
end
