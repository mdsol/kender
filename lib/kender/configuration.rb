module Kender

  # This class abstracts access to configuration values. Currently, the values
  # are read from the environment.
  #
  class Configuration
    def method_missing(name)
      ENV[name.to_s.upcase]
    end
  end
end
