# Kender

Kender provides general tasks for the Continuous Integration system.
The goal is to be project and CI agnostic.

## Usage

Add the following to your `Gemfile`:

```ruby
group :development, :test do
  gem 'kender', :git => 'git@github.com:mdsol/kender.git'
  gem 'shamus', :git => 'git@github.com:mdsol/shamus.git', :tag => '0.9.6'
  gem 'brakeman', '~> 1.8'
end
```

Kender currently assumes you are using the [Shamus][s] and [Brakeman][b] tools,
so these must be included in your `Gemfile` too. Specify versions appropriate
for your project; the examples versions shown above are just for illustration.

[s]: https://github.com/mdsol/shamus
[b]: TODO

This gem and it's dependencies should not be deployed in production, so scope
them to appropriate stages as shown above.

Kender assumes that you have the following rake tasks defined locally in your
project:

* `config:all`
* `db:migrate`
* `db:create`
* `db:drop`

To create `config:all` we strongly recommend you use Kender's companion [Dice
Bag][db] gem:

```ruby
gem 'dice_bag', :git => 'git@github.com:mdsol/dice_bag.git'
```

[db]: https://github.com/mdsol/dice_bag

Unlike Kender, Dice Bag is intended for use in all stages, including production.

The `db` tasks are assumed to work like those found in Rails.

If you are using these tasks outside of a Rails project, add the following to
your `Rakefile` or wherever your local rake tasks are defined:

```ruby
require 'kender/tasks'
```

Run the following command to see the new tasks:

```
[bundle exec] rake -D ci
```

### Running locally

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

### Setting commit status in GitHub

The `ci` task will update the current `HEAD` commit in the associated GitHub
repo. To do so, a [GitHub OAuth][go] authorization token is required and must be
provided in the `GITHUB_AUTH_TOKEN` environment variable, for example:

```
[bundle exec] rake GITHUB_AUTH_TOKEN=123... ci
```

[go]: http://developer.github.com/v3/oauth/

CI servers like Jenkins let you set system-wide environment variables, saving
the need of specifying this in every job. The status update is skipped if no
token is provided.

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

[je]: https://wiki.jenkins-ci.org/display/JENKINS/Building+a+software+project#Buildingasoftwareproject-JenkinsSetEnvironmentVariables

## Owners

* [Andrew Smith](mailto:asmith@mdsol.com)
* [Jordi Carres](mailto:jcarres@mdsol.com)

