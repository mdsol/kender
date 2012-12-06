module Kender
  class Shamus < Command

    def initialize
      @command = 'bundle exec shamus'
    end

    # we only run shamus if the we are told so
    def available?
      defined?(::Shamus) && ENV['VALIDATE_PROJECT']
    end

  end
end
