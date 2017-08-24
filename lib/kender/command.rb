module Kender
  # This class abstracts the shell commands we use
  class Command
    attr_reader :success

    def name
      self.class.name.split("::").last.downcase.to_sym
    end

    def available?
      abort "Command failed: #{name}, availability status undefined."
    end

    def execute
      @success = run.success?
    end

    #TODO: system reload all the gems again, avoid this.
    def run
      system(command)
      $?
    end

    class << self

      def all_success?
        all.inject(true) {|all_result, command_result| all_result && command_result }
      end

      def commands
        @commands ||= []
      end

      def inherited(klass)
        commands << klass.new
      end

      def all_names
        all.map(&:name)
      end

      def all
        @all ||= begin
          all_commands = commands.select(&:available?)
          # move rspec and cucumber to last places so faster tools run first
          if command = all_commands.find{ |command| command.name == :rspec }
            all_commands.delete_if{ |command| command.name == :rspec }.push(command)
          end
           if command = all_commands.find{ |command| command.name == :cucumber }
            all_commands.delete_if{ |command| command.name == :cucumber }.push(command)
          end
          all_commands
        end
      end

    end

    private

    def in_gemfile?(gem_name)
      Bundler.definition.dependencies.any?{ |dep| dep.name == gem_name }
    end

  end
end

require_relative 'commands/consistency_fail'
require_relative 'commands/jasmine'
require_relative 'commands/brakeman'
require_relative 'commands/bundle_audit'
require_relative 'commands/shamus'
require_relative 'commands/test_unit'
require_relative 'commands/factorygirl_lint'
require_relative 'commands/rspec'
require_relative 'commands/cucumber'
require_relative 'commands/reek'
require_relative 'commands/i18n_tasks'
require_relative 'commands/pb_duplicates'
require_relative 'commands/rdlint'
