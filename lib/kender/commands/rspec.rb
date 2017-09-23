module Kender
  class Rspec < Command

    def available?
      # do not run if running shamus
      return false if ENV['VALIDATE_PROJECT']
      in_gemfile?("rspec") || in_gemfile?("rspec-rails")
    end

    def command
      if defined?(Knapsack)
        knapsack_env = "CI_NODE_TOTAL=#{ENV['CI_NODE_TOTAL']} CI_NODE_INDEX=#{ENV['CI_NODE_INDEX']}"
        "#{knapsack_env} bundle exec rake knapsack:rspec"
      elsif defined?(ParallelTests)
        'bundle exec rake parallel:spec'
      else
        'bundle exec rspec'
      end
    end

  end
end
