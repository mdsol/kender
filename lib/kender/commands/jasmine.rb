module Kender
  # Jasmine is a unit testing framework for javascript similar to rspec.
  class Jasmine < Command

    # check whether to actually run this command
    def available?
      # do not run if running shamus
      return false if ENV['VALIDATE_PROJECT']

      # make sure those gems were added
      return false unless in_gemfile?("jasmine")

      # verify jasmine and phantomjs are both present
      `phantomjs --version 2>&1 > /dev/null`
      return false unless $?.success?
      `bundle exec jasmine license`
      $?.success?
    end

    def command
      if in_gemfile?("jasmine-phantom")
        #This is nicer as will install phantomJS for us.
        'bundle exec rake jasmine:phantom:ci'
      else
        'bundle exec rake jasmine:ci'
      end
    end

  end
end

