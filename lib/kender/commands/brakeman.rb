module Kender
  class Brakeman < Command

    def initialize
      # Make warnings fail the build with the '--exit-on-warn' switch.
      command = 'bundle exec brakeman --quiet --exit-on-warn'
      super(command)
    end

     def available?
      defined?(::Brakeman)
    end

  end
end
