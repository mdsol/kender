module Kender
  class Features < Command

    def setup
      # we run cucumber when we are not running Shamus
      return false if ENV['VALIDATE_PROJECT']
      
      if defined?(Cucumber)
        if defined?(ParallelTests)
          set_command('rake parallel:features')
        else
          set_command('bundle exec cucumber')
        end
      end
    end

  end
end
