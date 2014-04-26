module Kender
  class Brakeman < Command

    def available?
      Gemfile.contains?('brakeman')
    end

    def command
      'bundle exec brakeman --quiet --exit-on-warn'
    end

  end
end
