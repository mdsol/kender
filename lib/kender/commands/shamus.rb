module Kender
  class Shamus < Command

    def available?
      in_gemfile?("shamus") and ENV['VALIDATE_PROJECT']
    end

    def command
      'bundle exec shamus'
    end
  end
end
