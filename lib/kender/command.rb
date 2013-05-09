module Kender
  # This class abstracts the shell commands we use
  class Command

    def name 
      self.class.name.split("::").last.downcase.to_sym
    end

    def task_name
      "ci:#{name}"
    end

    def available?
      raise RuntimeError, "Command failed: #{name}, availability status undefined."
    end

    def execute
      raise RuntimeError, "Command failed: #{command}" unless run.success?
    end

    #TODO: system reload all the gems again, avoid this.
    def run
      system(command)
      $?
    end

    class << self 

      def commands
        @commands ||= []
      end

      def inherited(klass)
        commands << klass.new
      end

      def all_tasks
        all.map(&:task_name)
      end

      def all
        @all ||= commands.select(&:available?)
      end

    end
  end
end

require_relative 'commands/jasmine'
require_relative 'commands/brakeman'
require_relative 'commands/bundle_audit'
require_relative 'commands/shamus'
require_relative 'commands/test_unit'
require_relative 'commands/rspec'
require_relative 'commands/cucumber'
