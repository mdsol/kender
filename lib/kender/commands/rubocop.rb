module Kender
  class Rubocop < Command

    def available?
      in_gemfile?('rubocop')
    end

    def command
      'bundle exec rubocop .'
    end

  end
end
