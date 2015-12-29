# Kender

Kender provides a consistent framework for continuous integration (CI). The
principles of Kender are:

* The definition of what constitutes your CI runs is dependent on your code, so
  it should be managed alongside that code and not isolated in your CI server's
  configuration.

* CI runs are executed the same way, wherever they run, whoever runs them.
  Developers should be able to execute the same, simple command on their local
  machines to execute a CI run as is used on a dedicated CI server. No more
  publishing a branch that requires a CI configuration change, unsure of whether
  the CI server will pass or fail.

* CI runs are executed the same way on every branch. A single CI project
  configuration should be suitable for every branch. No more mysterious failures
  on the CI server due to branch changes being incompatible with the current CI
  project configuration.

* CI runs have directly visible status, e.g. in the GitHub pull requests. No
  more merging bad branches.

## Usage

Add the following to your `Gemfile`:

```ruby
group :development, :test do
  gem 'kender', '~> 0.3'
end
```

This gem and its dependencies should not be deployed in production, hence the
`group` above.

Kender-based CI runs are executed using the `ci` rake task. The following rake
tasks defined locally in your project will be run at the appropriate point in
the process if they exist:

* `config:deploy`
* `db:migrate`
* `db:create`
* `db:drop`

`config:deploy` is defined in the [DiceBag][db] gem.
It will always overwrite the configuration files with the values in the templates.

[db]: https://github.com/mdsol/dice_bag

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

### Execute a CI run

The rake `ci` task can be run locally in precisely the same way as it should be
on a CI server:

```
rake ci
```

This executes the three sub-tasks `ci:config`, `ci:run` and `ci:clean`. Each of
these can be run in isolation.

Configuration typically requires values to be provided. Using DiceBag, this can
be done through environment variables passed on the rake command line. For
example, in a typical Rails project you would use the following:

```
rake DATABASE_USERNAME=root DATABASE_PASSWORD=password DATABASE_NAME=test ci
```

To bypass any configuration and clean-up side effects, for example if your
application is already configured, execute just the `ci:run` task.

### Configuring what is included in the CI run

Kender will detect the test-related gems in your Gemfile and execute whatever
CI-related commands make sense. Just ensure the gem is available in at least
your test and development environments.

Currently supported gems are:

#### Cucumber

The [Cucumber][c] features will be run. Normally no command-line parameters or switches
are passed, so ensure your default profile is correct for a CI run. If the
cucumber command fails, the CI run will fail.

If you want to run scenarios that require a headed web browser, you can tell Kender
to use a specific browser as part of the CI run. You can set the environment
variable `HEADED_BROWSER` to the name of the browser you want to run. Verify your project
can use the `HEADED_BROWSER` environment variable.

[c]: https://github.com/cucumber/cucumber

#### RSpec

The [RSpec][r] specs will be run. No command-line parameters or switches are
passed, so ensure your defaults in `.rspec` are correct for a CI run. If the
rspec command fails, the CI run will fail.

[r]: https://github.com/rspec/rspec

#### Jasmine

The [Jasmine][j] rake task `jasmine:phantom:ci` will be run. If the task fails,
the CI run will fail.

Additionally, you must have [PhantomJS][ph] pre-installed on the system doing
the CI run.

[j]: https://github.com/pivotal/jasmine-gem
[ph]: http://phantomjs.org/

#### Brakeman

The [Brakeman][b] command is run in quiet mode. If any warnings are generated,
the CI run will fail.
  
[b]: http://brakemanscanner.org/

#### Bundler Audit

The [Bundler-audit][a] `check` command is run. If any checks fail, the CI run
will fail.

[a]: https://github.com/postmodern/bundler-audit

#### Reek

The [Reek][r] command is run in quiet mode. The CI run will not fail, regardless
of the output.

[r]: https://github.com/troessner/reek

#### Consistency Fail

The [Consistency Fail][cf] command is run. The CI run will not fail, regardless
of the output.

[cf]: https://github.com/trptcolin/consistency_fail/

#### I18n Tasks

The [I18n Tasks][i] commands to check for both missing and unused translations are executed.
The CI run will not fail, regardless of the output.

[i]: https://github.com/glebm/i18n-tasks

#### Shamus

The [Shamus][s] command is run. If the command fails, the CI run will fail.

When Shamus is used, RSpec, Jasmine and Cucumber are not run directly by Kender
but delegated to Shamus instead. As you may not want to run Shamus by default in
a CI context, you must set the environment variable `VALIDATE_PROJECT`:

```
rake VALIDATE_PROJECT=true ci
```

[s]: https://github.com/mdsol/shamus

#### Crichton Rdlint

The [Crichton rdlint][cr] command is run.  If the command fails, the CI run will fail.
If there is no api_descriptors directory in the project, the command will not be run.

[cr]: https://github.com/mdsol/crichton/blob/develop/doc/lint.md

#### FactoryGirl Lint

The [FactoryGirl lint][fgl] command is run. If the command fails, the CI run will fail.
If there is no `factory_girl_lint.rake` file in the `lib/tasks` directory of the project, the command will not be run.

[fgl]: https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md#linting-factories

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

If you are using multiple remotes, you may specify one with the environment
variable `GITHUB_REMOTE`:

```
[bundle exec] rake GITHUB_REMOTE=personal ci
```

if you are using Jenkins with multiple remotes, you may want to have it automatically select the right
one for you. Here is a quick bash trick you can use.

```bash
export GITHUB_REMOTE=`echo "$GIT_BRANCH" | awk -F / '{print $1}'`
```

[je]: https://wiki.jenkins-ci.org/display/JENKINS/Building+a+software+project#Buildingasoftwareproject-JenkinsSetEnvironmentVariables


## Development

Tests are run with:
```bash
bundle exec cucumber
```

They need a modern bundler ( > 1.10) to work.

## Contributors

* [Andrew Smith](https://github.com/asmith-mdsol)
* [Jordi Carres](https://github.com/jcarres-mdsol)
* [Mathieu Jobin](https://github.com/mjobin-mdsol)
* [Will Duty](https://github.com/wdutymdsol)
* [Michael West](https://github.com/miwest929)
* [Ezra Jennings](https://github.com/ejennings-mdsol)
