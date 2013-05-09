module Kender
  class Shamus < Command

    def available?
      defined?(Shamus) and ENV['VALIDATE_PROJECT']
    end

    def command
      'bundle exec shamus'
    end
  end
end
