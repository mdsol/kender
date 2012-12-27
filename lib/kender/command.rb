module Kender
  # This class abstracts the shell commands we use
  class Command

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

    #TODO: system reload all the gems against, avoid this.
    def run(command)
      system(command)
      $?
    end

    # I use this method insted of the more rubyist command= because it
    # feels more explicit and obvious
    def set_command(command)
      @command = command
    end

    def available?
      !@command.nil?
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
        @all ||= commands.map(&:new).select { |c| c.setup && c.available? }
      end

    end
  end
end

require_relative 'commands/security'
require_relative 'commands/validation'
require_relative 'commands/features'
require_relative 'commands/specs'
