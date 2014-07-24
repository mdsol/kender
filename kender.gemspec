require File.expand_path('../lib/kender/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'kender'
  s.version = Kender::VERSION
  s.platform = Gem::Platform::RUBY

  s.authors = ['Andrew Smith', 'Jordi Polo', 'Michael West', 'Ezra Jennings']
  s.email = ['asmith@mdsol.com', 'jcarres@mdsol.com', 'mwest@mdsol.com', 'ejennings@mdsol.com']
  s.summary = 'Kender is a library of rake tasks that provides a consistent framework for continuous integration (CI).'
  s.license = 'MIT'

  s.files = Dir['lib/**/*']
  s.test_files = Dir['features/**/*']
  s.executables = Dir['bin/*'].map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'bundler'
  s.add_development_dependency 'aruba', '~> 0.5.4'
  s.add_development_dependency 'rake'
end
