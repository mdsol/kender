module Kender
  class Cucumber < Command

    def initialize
      command = 'bundle exec cucumber'
      super(command)
    end

    # we run cucumber when we are not running Shamus
    def available?
      #this is slow as bundle exec can prove to be quite slow in old rubies
      return false if ENV['VALIDATE_PROJECT']
      `bundle exec cucumber --version`
      $?.success?
    end

  end
end
