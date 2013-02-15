module Kender
  class BundleAudit < Command

    def initialize
      # Make warnings fail the build with the '--exit-on-warn' switch.
      command = 'bundle exec bundle-audit --exit-on-warn'
      super(command)
    end

    def available?
      defined?(::Bundle::Audit)
    end

  end
end
