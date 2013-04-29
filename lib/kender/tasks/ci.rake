require 'kender/configuration'
require 'kender/github'
require 'kender/command'

# Helper method to call rake tasks without blowing up when they do not exists
# @Return: false when it could not be executed or there was some error.
def run_successfully?(tasks)
  [*tasks].inject(true) do |result, task|
    result && if Rake::Task.task_defined?(task)
      Rake::Task[task].invoke
    end
  end
end

# This is the task we want the user to use all the time.
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

  # UI for the user, these are tasks the user can use
  desc "Configure the app to run continuous integration tests"
  task :config => ['ci:env', 'ci:config_project', 'ci:setup_db']

  desc "Run continuous integration tests with the current configuration"
  task :run =>  ['ci:env'] + Kender::Command.all_tasks

  desc "Destroy resources created externally for the continuous integration run, e.g. drops databases"
  task :clean => ['ci:env', 'ci:drop_db']


  # These tasks are internal to us, without description, the user can not discover them
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

  task :config_project do
    unless run_successfully?('config:all')
      puts 'Your project could not be configured, a config:all task needed. Consider installing dice_bag'
    end
  end


  # TODO:  Could depend on 'db:schema:load' or 'db:setup' here instead of 'db:migrate'
  # if the 'db/schema.rb' file was committed to the repo (as per Rails
  # recommendations).
  task :setup_db do
    unless run_successfully?(['db:create', 'db:migrate'])
      puts 'The DB could not be set up. Define db:create and db:migrate for your test environment'
    end
  end

  task :drop_db do
    unless run_successfully?('db:drop')
      puts 'The DB could not be torn down. Define db:drop in your test environment'
    end
  end

  Kender::Command.all.each do |command|
    task command.name do 
      command.execute
    end
  end


  #Tasks related to updating the status in Github
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
