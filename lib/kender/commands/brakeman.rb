module Kender
  class Brakeman < Command

    def available?
      defined?(::Brakeman)
    end

    def command
      'bundle exec brakeman --quiet --exit-on-warn'
    end

  end
end
