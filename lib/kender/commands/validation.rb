module Kender
  class Validation < Command

    def setup
      # we only run shamus if the we are told so
      return false if !ENV['VALIDATE_PROJECT']
      if defined?(Shamus)
        set_command('bundle exec shamus')
      end
    end
  end
end
