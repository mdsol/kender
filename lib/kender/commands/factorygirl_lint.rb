module Kender
  class FactoryGirlLint < Command

    def available?
      File.exist?(File.join(Dir.pwd, 'lib', 'tasks', 'factory_girl_lint.rake'))
    end

    def command
      'bundle exec rake factory_girl:lint'
    end

  end
end
