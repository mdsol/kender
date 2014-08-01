module Kender
  class Cucumber < Command

    def available?
      in_gemfile?('cucumber') and not(ENV['VALIDATE_PROJECT'])
    end

    def command
      extra_env = ENV['HEADED_BROWSER'] ? "HEADED_BROWSER=#{ENV['HEADED_BROWSER']}" : ''
      if defined?(ParallelTests)
        "#{extra_env} bundle exec rake parallel:features"
      else
        "#{extra_env} bundle exec cucumber"
      end
    end

  end
end
