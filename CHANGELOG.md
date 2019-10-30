# 0.7.0
* Run brakeman in the same ruby process

# 0.6.0
* knapsack support for cucumber and rspec (https://github.com/ArturT/knapsack)

# 0.5.0
* Removes functionality regarding Github
* Adds ci:fail_fast task to allow CI to finish at the first failure

# 0.4.0
* Use db:schema:load instead of db:migrate which was causing schema changes in some projects

# 0.3.3
* Allow dice_bag 1.x as a dependency

# 0.3.2
* Run the factory_girl:lint task if it is available

# 0.3.1
* Allow Jasmine to run even when Jasmine-phantom is not in the Gemfile

# 0.3.0
* Use config:deploy instead of config:all rake task.
  config:deploy will always overwrite every config file without asking.
* Kender depends on dice_bag. Realistically probably noone was using it
  without dice_bag so not need of supporting the ability of doing so.
  It is a backwards-incompatible change for those using their own
config:all rake task.
* Kender needs Ruby 1.9.3 or superior

# 0.2.6
* Updated to check for cucumber-rails in addition to cucumber

# 0.2.5
* Updated to only check for gems explicitly declared in Gemfile

# 0.2.4
* Adds support for running with the headed_browser env variable

# 0.2.3
* Adds support for Crichton lint.

# 0.2.2
* Adds support for i18n-tasks gem.

# 0.2.1
* Add support for pb_numbers rake task to ensure all your scenarios are uniquely identified

# 0.2
* Kender do not create magic task per command. Avoid slowing down Rake.

# 0.1.7
* Bugfix: Support for projects using WebMock

# 0.1.6
* Consistency_fail support
* Bugfix: Only execute with bundle exec gems in the Gemfile
* github subdomains support and customizable remote name

# 0.1.5
* parallel-test support

# 0.1.4
* bundler-audit support

# 0.1.3
* jasmine support

# 0.1.2
* Ensure db:migrate is called
* Ensure fails kill the ci task

# 0.1.1
* Initial release
