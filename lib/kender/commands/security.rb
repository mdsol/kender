module Kender
  class Security < Command

    def setup
      if defined?(::Brakeman)
        set_command( 'bundle exec brakeman --quiet --exit-on-warn')
      end
    end

  end
end
