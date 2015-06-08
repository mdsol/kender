module Kender
  class Rdlint < Command

    def available?
      in_gemfile?('crichton') && Dir.exists?(File.join(Dir.pwd, 'api_descriptors'))
    end

    def command
      'bundle exec rdlint -as'
    end

  end
end
