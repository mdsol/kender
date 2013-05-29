module Kender
  class Brakeman < Command

    def available?
      in_gemfile?('brakeman')
    end

    def command
      'bundle exec brakeman --quiet --exit-on-warn'
    end

  end
end
