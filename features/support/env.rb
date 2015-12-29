require 'aruba/cucumber'
require 'kender'

Before do
  #scenarios bundle to set up gems and it takes forever
    @aruba_timeout_seconds = 30
end

