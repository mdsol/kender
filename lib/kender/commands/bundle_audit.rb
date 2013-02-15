module Kender
  class BundleAudit < Command

    def initialize
      # This commands fails if there are any problems.
      command = 'bundle exec bundle-audit check'
      super(command)
    end

    def available?
      defined?(::Bundle::Audit)
    end

  end
end
