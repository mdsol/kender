module Kender
  class Railtie < Rails::Railtie
    rake_tasks do
      require 'kender/tasks'
    end
  end
end
