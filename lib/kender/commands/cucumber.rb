module Kender
  class Cucumber < Command

    def initialize
      command = 'bundle exec cucumber'
      super(command)
    end

    # we run cucumber when we are not running Shamus
    def available?
      cucumber_files = File.join(Dir.pwd, 'features')
      File.exists?(cucumber_files) && !ENV['VALIDATE_PROJECT']
    end

  end
end
