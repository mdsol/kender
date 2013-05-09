module Kender
  class Brakeman < Command

    def available?
      defined?(::Brakeman)
    end

    def command
      if available?
        'bundle exec brakeman --quiet --exit-on-warn'
      end
    end

  end
end
