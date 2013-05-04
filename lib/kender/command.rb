module Kender
  # This class abstracts the shell commands we use
  class Command

    def initialize(command)
      @command = command
    end

    def name 
      self.class.name.split("::").last.downcase.to_sym
    end

    def task_name
      "ci:#{name}"
    end

    # by default all the commands are available
    def available?
      true
    end

    def execute
      if !run(@command).success?
        raise RuntimeError, "Command failed: #{@command}"
      end
    end

    def run(command)
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
        commands.map(&:new).select { |c| c.available? }
      end

    end
  end
end

require_relative 'commands/jasmine'
require_relative 'commands/brakeman'
require_relative 'commands/bundle_audit'
require_relative 'commands/shamus'
require_relative 'commands/rspec'
require_relative 'commands/cucumber'
