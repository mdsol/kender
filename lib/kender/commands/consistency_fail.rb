module Kender
  class ConsistencyFail < Command

    def available?
      in_gemfile?("consistency_fail")
    end

    def command
      'bundle exec consistency_fail'
    end

  end
end
