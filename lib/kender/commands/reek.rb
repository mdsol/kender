module Kender
  class Reek < Command

    def available?
      `reek -v`
      $?.success?
    end

    def command
      # doing simple echo to ignore error status.
      'reek app lib; echo ok'
    end

  end
end
