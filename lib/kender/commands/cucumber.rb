module Kender
  class Cucumber < Command

    def available?
      %w[cucumber cucumber-rails].any? { |gem| in_gemfile?(gem) } && !ENV['VALIDATE_PROJECT']
    end

    def command
      extra_env = ENV['HEADED_BROWSER'] ? "HEADED_BROWSER=#{ENV['HEADED_BROWSER']}" : ''
      retry_command = ENV['CUCUMBER_RETRY'] ? ' --profile rerun' : ''
      retry_command_knapsack = ENV['CUCUMBER_RETRY'] ? '_rerun:record' : ''
      if defined?(Knapsack)
        knapsack_env = "CI_NODE_TOTAL=#{ENV['CI_NODE_TOTAL']} CI_NODE_INDEX=#{ENV['CI_NODE_INDEX']}"
        "#{extra_env} #{knapsack_env} bundle exec rake knapsack:cucumber#{retry_command_knapsack}"
      elsif defined?(ParallelTests)
        "#{extra_env} bundle exec rake parallel:features"
      else
        "#{extra_env} bundle exec cucumber#{retry_command}"
      end
    end
  end
end
