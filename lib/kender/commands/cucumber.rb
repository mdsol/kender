module Kender
  class Cucumber < Command

    def available?
      %w[cucumber cucumber-rails].any? { |gem| in_gemfile?(gem) } && !ENV['VALIDATE_PROJECT']
    end

    def command
      extra_env = ENV['HEADED_BROWSER'] ? "HEADED_BROWSER=#{ENV['HEADED_BROWSER']}" : ''
      if defined?(Knapsack)
        Rails.logger.error "starting knapsack!"
        Rails.logger.error "ENV['CI_NODE_TOTAL']: #{ENV['CI_NODE_TOTAL']}"
        Rails.logger.error "ENV['CI_NODE_INDEX']: #{ENV['CI_NODE_INDEX']}"
        "CI_NODE_TOTAL=#{ENV['CI_NODE_TOTAL']} CI_NODE_INDEX=#{ENV['CI_NODE_INDEX']} bundle exec rake knapsack:cucumber"
      elsif defined?(ParallelTests)
        "#{extra_env} bundle exec rake parallel:features"
      else
        "#{extra_env} bundle exec cucumber"
      end
    end

  end
end
