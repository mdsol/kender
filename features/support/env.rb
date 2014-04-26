require 'aruba/cucumber'
require 'kender'

Before do
  #scenarios bundle to set up gems and it takes forever
    @aruba_timeout_seconds = 30
end

# Unset bundle vars so when we create new bundle files in the scenarios 
# we use those gems there instead of the ones loaded by kender gem
Before('@redo_bundle') do
  unset_bundler_env_vars
end
