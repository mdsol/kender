module Kender
  class Specs < Command

    def setup
      # When we run a validation command we assume any other command will not be run
      return false if ENV['VALIDATE_PROJECT']

      if defined?(ParallelTests)
        if defined?(RSpec)
          set_command('rake parallel:spec')
        elsif defined(Test::Unit)
          set_command('rake parallel:test')
        end
      else
        if defined?(RSpec)
          set_command('bundle exec rspec')
        elsif defined?(Test::Unit)
          set_command('rake test')
        end
      end

    end

  end
end
