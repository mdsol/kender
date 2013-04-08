module Kender
  class Jasmine < Command

    def initialize
      command = 'bundle exec rake jasmine:phantom:ci'
      super(command)
    end

    # check whether to actually run this command
    def available?
      # do not run if running shamus
      return false if ENV['VALIDATE_PROJECT']

      # verify jasmine and phantomjs are present
      `phantomjs --version`
      return false unless $?.success?
      `bundle exec jasmine license`
      $?.success?
    end

  end
end
