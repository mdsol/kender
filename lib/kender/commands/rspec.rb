module Kender
  class Rspec < Command

    def available?
      # do not run if running shamus
      return false if ENV['VALIDATE_PROJECT']
      in_gemfile?("rspec") || in_gemfile?("rspec-rails")
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
