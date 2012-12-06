module Kender
  class Cucumber < Command

    def initialize
      @command = 'bundle exec cucumber'
    end

    # we run cucumber when we are not running Shamus
    def available?
      defined?(::Cucumber) && !ENV['VALIDATE_PROJECT']
    end

  end
end
