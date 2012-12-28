module Kender
  class Validation < Command

    def available?
      defined?(Shamus) and ENV['VALIDATE_PROJECT']
    end

    def command
      if available?
        'bundle exec shamus'
      end
    end
  end
end
