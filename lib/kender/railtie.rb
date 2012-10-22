module Kender
  class Railtie < Rails::Railtie
    railtie_name :kender

    rake_tasks do
      require 'kender/tasks'
    end
  end
end
