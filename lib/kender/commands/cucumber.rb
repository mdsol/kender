module Kender
  class Features < Command

    def available?
      defined?(Cucumber) and not(ENV['VALIDATE_PROJECT'])
    end

    def command
      if available?
        if defined?(ParallelTests)
          'rake parallel:features'
        else
          'bundle exec cucumber'
        end
      end
    end

  end
end
