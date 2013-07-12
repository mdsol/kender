#make sure we require all the tools we need loaded in memory
Bundler.require(:default, :test)

require 'kender/configuration'
require 'kender/github'
require 'kender/command'

desc "Configure and run continuous integration tests then clean up"
task :ci => ['ci:status:pending'] do
  begin
    Rake::Task["ci:config"].invoke
    Rake::Task["ci:run"].invoke
    Rake::Task["ci:status:success"].invoke
  rescue Exception => e
    Rake::Task["ci:status:failure"].invoke

    # Ensure that this task still fails.
    raise e
  ensure
    Rake::Task["ci:clean"].invoke
  end
end

namespace :ci do

  desc "Configure the app to run continuous integration tests"
  # Could depend on 'db:schema:load' or 'db:setup' here instead of 'db:migrate'
  # if the 'db/schema.rb' file was committed to the repo (as per Rails
  # recommendations).
  task :config => ['ci:env', 'config:all', 'ci:setup_db']

  desc "Run continuous integration tests with the current configuration"
  task :run =>  ['ci:env'] + Kender::Command.all_tasks

  desc "Destroy resources created externally for the continuous integration run, e.g. drops databases"
  task :clean => ['ci:env', 'ci:drop_db']

  task :env do
    if defined?(Rails)
      # Default to the 'test' environment unless otherwise specified. This
      # ensures that 'db:*' tasks are run on the correct (default) database for
      # later tasks like 'spec'.
      ENV['RAILS_ENV'] ||= 'test'
      Rails.env = ENV['RAILS_ENV']
    else
      ENV['RACK_ENV'] ||= 'test'
    end
  end

  # Automatically create rake task for each individual command.
  Kender::Command.all.each do |command|
    desc "Individual task for #{command.name}, in parallel if available."
    task command.name do
      command.execute
    end
  end

  desc "Generic task to setup your databases, in parallel if available."
  task :setup_db do
    if Rake::Task.task_defined?('db:create')
      if !defined?(ParallelTests)
        Rake::Task['db:create'].invoke
        Rake::Task['db:migrate'].invoke
      else
        #TODO: invoke on the task did not work. Why?
        system('bundle exec rake parallel:create')
        system('bundle exec rake parallel:prepare')
      end
    else
      puts "no databases tasks found."
    end
  end

  desc "Generic task to drop your databases, in parallel if available."
  task :drop_db do
    if Rake::Task.task_defined?('db:drop')
      if !defined?(ParallelTests)
        Rake::Task['db:drop'].invoke
      else
        #TODO: invoke on the task did not work. Why?
        system('bundle exec rake parallel:drop')
      end
    else
      puts "no databases tasks found."
    end
  end

  namespace :status do

    config = Kender::Configuration.new

    task :pending do
      Kender::GitHub.update_commit_status(:pending, config)
    end
    task :success do
      Kender::GitHub.update_commit_status(:success, config)
    end
    task :failure do
      Kender::GitHub.update_commit_status(:failure, config)
    end
  end
end
