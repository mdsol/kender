module Kender
  class Rspec < Command

    def initialize
      @command = 'bundle exec rspec'
    end

    # we run cucumber when we are not running Shamus
    def available?
      defined?(::RSpec) && !ENV['VALIDATE_PROJECT']
    end

  end
end
