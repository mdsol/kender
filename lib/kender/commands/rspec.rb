module Kender
  class Rspec < Command

    def available?
      # TODO: consider creating a separate command for Test::Unit
      (defined?(RSpec) or defined?(Test::Unit)) and not(ENV['VALIDATE_PROJECT'])
    end

    def command
      if defined?(ParallelTests)
        if defined?(RSpec)
          'rake parallel:spec'
        elsif defined?(Test::Unit)
          'rake parallel:test'
        end
      else
        if defined?(RSpec)
          'bundle exec rspec'
        elsif defined?(Test::Unit)
          'rake test'
        end
      end
    end

  end
end
