module Kender
  class Cucumber < Command

    def available?
      %w[cucumber cucumber-rails].any? { |gem| in_gemfile?(gem) } && !ENV['VALIDATE_PROJECT']
    end

    def command
      extra_env = ENV['HEADED_BROWSER'] ? "HEADED_BROWSER=#{ENV['HEADED_BROWSER']}" : ''
      if defined?(Knapsack)
        Rails.logger.error "starting Knapsack!"
        Rails.logger.info "starting Knapsack!"
        puts "starting Knapsack!"
        "CI_NODE_TOTAL=#{ENV['CI_NODE_TOTAL']} CI_NODE_INDEX=#{ENV['CI_NODE_INDEX']} bundle exec rake knapsack:cucumber"
      elsif defined?(ParallelTests)
        Rails.logger.error "starting ParallelTests!"
        Rails.logger.info "starting ParallelTests!"
        puts "starting ParallelTests!"
        "#{extra_env} bundle exec rake parallel:features"
      else
        Rails.logger.error "starting cucumber!"
        Rails.logger.info "starting cucumber!"
        puts "starting cucumber!"
        "#{extra_env} bundle exec cucumber"
      end
    end

  end
end
