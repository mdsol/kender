module Kender
  class CypressRails < Command

    # Kender might be in some projects which use cypress-rails but
    # do not have this rake task.
    def available?
      in_gemfile?('cypress-rails') && Rake::Task.task_defined?('cypress_extended:enhanced_run')
    end

    def command
      'bundle exec rake cypress_extended:enhanced_run'
    end

  end
end
