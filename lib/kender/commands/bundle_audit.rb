module Kender
  class BundleAudit < Command

    def available?
      defined?(::Bundler::Audit)
    end

    def command
      # This commands fails if there are any problems.
      'bundle exec bundle-audit check'
    end

  end
end
