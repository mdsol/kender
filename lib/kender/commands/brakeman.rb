module Kender
  class Brakeman < Command

    def available?
      in_gemfile?('brakeman')
    end

    def execute
      require 'brakeman'

      result = ::Brakeman.run(app_path: '.', print_report: true, quiet: true)
      @success = result.errors.none? && result.warnings.none?
    end

  end
end
