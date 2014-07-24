module Kender
  class Cucumber < Command

    def available?
      in_gemfile?("cucumber") and not(ENV['VALIDATE_PROJECT'])
    end

    def command
      if defined?(ParallelTests)
        'bundle exec rake parallel:features'
      elsif ENV['CUCUMBER_RERUNS']
        Array.new(ENV['CUCUMBER_RERUNS'].to_i + 1, 'bundle exec cucumber -p rerun').join(' || ')
      else
        'bundle exec cucumber'
      end
    end

  end
end
