# Kender

Kender is a library of rake tasks that provides a consistent framework for
continuous integration (CI). The principles of Kender are:

* CI runs are executed the same way by everyone. Developers should be able to
  execute the same, simple command on their machines to perform a CI run as is
  used on a dedicated CI server. No more publishing a branch unsure of whether
  the CI server will pass or fail.

* CI runs are executed the same way on every branch. A single CI project
  configuration should be suitable for every branch. No more mysterious failures
  on the CI server due to branch changes being incompatible with the current CI
  project configuration.

* CI runs have directly visible status, e.g. in the GitHub pulls requests. No
  more merging bad branches.

## Usage

Add the following to your `Gemfile`:

```ruby
group :development, :test do
  gem 'kender', :git => 'git@github.com:mdsol/kender.git'
end
```

This gem and its dependencies should not be deployed in production, hence the
`group` above.

Kender assumes that you have the following rake tasks defined locally in your
project:

* `config:all`
* `db:migrate`
* `db:create`
* `db:drop`

To create `config:all` we strongly recommend you use Kender's companion [Dice
Bag][db] gem:

```ruby
gem 'dice_bag', '~> 0.6'
```

[db]: https://github.com/mdsol/dice_bag

Unlike Kender, Dice Bag is intended for use in all stages, including production.

The `db` tasks are assumed to work like those found in Rails.

If you are using these Kender tasks outside of a Rails project, add the following to
your `Rakefile` or wherever your local rake tasks are defined:

```ruby
require 'kender/tasks'
```

Run the following command to see the new tasks:

```
[bundle exec] rake -D ci
```

### Performing a CI run

The rake `ci` task can be run locally in precisely the same way as it should be
on a CI server:

```
rake ci
```

This performs the three sub-tasks `ci:config`, `ci:run` and `ci:clean`. Each of
these can be run in isolation.

Configuration typically requires values to be provided. Using the Dice Bag gem,
this can be done through environment variables passed on the rake command line.
For example, in a typical Rails project you would use the following:

```
rake DATABASE_USERNAME=root DATABASE_PASSWORD=password DATABASE_NAME=test ci
```

To bypass any configuration and clean-up side effects, for example if your
application is already configured, execute just the `ci:run` task.

### Configuring what software to be run by Kender

Kender will detect the gems of your project and will execute the maximum number of it possible.
Currently Kender execute the following software:

* [Cucumber][c]
  Add the following to your Gemfile to activate:
  ```ruby
  group :development, :test do
    gem 'cucumber'
  end
  ```

* [Rspec][r]
  Add the following to your Gemfile to activate:
  ```ruby
  group :development, :test do
    gem 'rspec'
  end
  ```

* [Jasmine][j]
  Add the following to your Gemfile to activate:
  ```ruby
  group :development, :test do
    gem 'jasmine'
  end
  ```
  Additionally you need to have installed [PhantomJS][ph] in the systems running the tests.

* [Brakeman][b]
  Add the following to your Gemfile to activate:
  ```ruby
  group :development, :test do
    gem 'brakeman'
  end
  ```
  
* [Bundler-audit][a]
  Add the following to your Gemfile to activate:
  ```ruby
  group :development, :test do
    gem 'bundler-audit', '~> 0.1'
  end
  ```

* [Reek][r]
  Add the following to your Gemfile to activate:
  ```ruby
  group :development, :test do
    gem 'reek', '~> 1.3'
  end
  ```

* [Consistency_fail][cf]
  Add the following to your Gemfile to activate:
  ```ruby
  group :development, :test do
    gem 'consistency_fail', '~> 0.3'
  end
  ```

* [Shamus][s]
  Add the following to your Gemfile to activate:
  ```ruby
  group :development, :test do
   gem 'shamus', :git => 'git@github.com:mdsol/shamus.git', :tag => '0.9.7'
  end
  ```
  Whenever Shamus is run, Rspec, Jasmine and Cucumber will not run. To make Shamus run, the environment variable 'VALIDATE_PROJECT' has to be set. 
  The following would execute Shamus:
  ```
  VALIDATE_PROJECT=true rake ci
  ```


[s]: https://github.com/mdsol/shamus
[b]: http://brakemanscanner.org/
[a]: https://github.com/postmodern/bundler-audit
[r]: https://github.com/troessner/reek
[c]: https://github.com/cucumber/cucumber
[r]: https://github.com/rspec/rspec
[j]: https://github.com/pivotal/jasmine-gem
[ph]: http://phantomjs.org/
[cf]: https://github.com/trptcolin/consistency_fail/

### Setting commit status in GitHub

The `ci` task sets the status of the current `HEAD` commit in the associated
GitHub repository. If this commit represents a topic (feature) branch, any
associated pull request will show the status of the CI run.

The GitHub repository is determined by examining the `origin` remote of the
current git repository.

To set the commit status, a [GitHub OAuth][go] authorization token is required
and must be provided in the `GITHUB_AUTH_TOKEN` environment variable, for
example:

```
[bundle exec] rake GITHUB_AUTH_TOKEN=123... ci
```

[go]: http://developer.github.com/v3/oauth/

CI servers like Jenkins let you set system-wide environment variables, saving
the need of specifying this in every job.

Create an authorization token with the following command:

```
curl -u <username> -d '{"scopes":["repo:status"],"note":"CI status updater"}' https://api.github.com/authorizations
```

You will be prompted for your GitHub account password.

The token is restricted to creating commit statuses only. The token is
associated to the given user, as are any commit statuses created through it. The
note given is the display name used in the GitHub account management pages.
Tokens can be revoked from there or via the API.

The commit status created uses the `BUILD_NUMBER` and `BUILD_URL` environment
variables as [provided by Jenkins][je]. Alternatively, these can be provided or
overridden on the command line, for example:

```
[bundle exec] rake BUILD_NUMBER=$MY_BUILD_NUM BUILD_URL=http://example.com/url ci
```

if you are using multiple remotes, you may specify one with the environment variable GITHUB_REMOTE
for example:

```
[bundle exec] rake GITHUB_REMOTE=personal ci
```

[je]: https://wiki.jenkins-ci.org/display/JENKINS/Building+a+software+project#Buildingasoftwareproject-JenkinsSetEnvironmentVariables

## Owners

* [Andrew Smith](mailto:asmith@mdsol.com)
* [Jordi Carres](mailto:jcarres@mdsol.com)

