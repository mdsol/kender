module Kender
  class Rspec < Command

    def initialize
      command = 'bundle exec rspec'
      super(command)
    end

    # we run cucumber when we are not running Shamus
    def available?
      #this is slow as bundle exec can prove to be quite slow in old rubies
      return false if ENV['VALIDATE_PROJECT']
      `bundle exec rspec --version`
      $?.success?
    end

  end
end
