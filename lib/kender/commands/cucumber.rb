module Kender
  class Cucumber < Command

    def available?
      in_gemfile?("cucumber") and not(ENV['VALIDATE_PROJECT'])
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
