module Kender
  class Shamus < Command

    def initialize
      command = 'bundle exec shamus'
      super(command)
    end

    # we only run shamus if the we are told so
    def available?
      #this is slow as bundle exec can prove to be quite slow in old rubies
      return false if !ENV['VALIDATE_PROJECT']
      `bundle exec shamus --help`
      $?.success?
    end
  end
end
