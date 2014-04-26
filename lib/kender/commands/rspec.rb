module Kender
  class Rspec < Command

    def available?
      # do not run if running shamus
      return false if ENV['VALIDATE_PROJECT']

      Gemfile.contains?("rspec") || Gemfile.contains?("rspec-rails")
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
