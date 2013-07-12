module Kender
  class BundleAudit < Command

    def available?
      in_gemfile?('bundler-audit')
    end

    def command
      # This commands fails if there are any problems.
      'bundle exec bundle-audit check'
    end

  end
end
