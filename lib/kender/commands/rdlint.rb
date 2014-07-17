module Kender
  class Rdlint < Command

    def available?
      in_gemfile?('crichton') && File.exists?(File.join(Dir.pwd, 'api_descriptors'))
    end

    def command
      'bundle exec rdlint -as'
    end

  end
end
