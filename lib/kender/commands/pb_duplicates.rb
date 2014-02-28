module Kender
  class PbDuplicates < Command
    def available?
      Rake::Task.task_defined?('pb:duplicates')
    end

    def command
      'bundle exec rake pb:duplicates'
    end
  end
end
