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

    #TODO: system reload all the gems against, avoid this.
    def run
      system(command)
      $?
    end

    class << self 

      def commands
        @commands ||= []
      end

      #TODO: if I store objects instead of classes it seems that the @command
      #become nil, WHY?!?
      def inherited(klass)
        commands << klass
      end

      def all_tasks
        all.map{|c| c.task_name  } 
      end

      def all
        @all ||= commands.map(&:new).select { |c| c.available? }
      end

    end
  end
end

require_relative 'commands/security'
require_relative 'commands/validation'
require_relative 'commands/features'
require_relative 'commands/specs'
