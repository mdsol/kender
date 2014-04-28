module Kender
  class PBDuplicates < Command
    def available?
      Rake::Task.task_defined?('pb_numbers:list:duplicates')
    end

    def command
      'bundle exec rake pb_numbers:list:duplicates'
    end
  end
end
