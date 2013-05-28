module Kender
  class Rspec < Command

    def available?
      in_gemfile?("rspec") and not(ENV['VALIDATE_PROJECT'])
    end

    def command
      if defined?(ParallelTests)
        'bundle exec rake parallel:spec'
      else
        'bundle exec rspec'
      end
    end

  end
end
